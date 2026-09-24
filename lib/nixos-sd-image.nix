# Turns an existing nixosSystem output into a bootable, custom SD image for its board,
# per https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi#Custom_SD_image
#
# Usage:
#   let sdImageFor = import ./lib/nixos-sd-image.nix { inherit nixpkgs; };
#   in sdImageFor self.nixosConfigurations.mora
#
# The per-host SSH host key (which doubles as the sops age identity, see
# `sops.age.sshKeyPaths`) is deliberately NOT baked through Nix: `pkgs.writeText`
# (or inlining the key into a build script) would put the private key in the Nix
# store, where it is world-readable — and since the encrypted `secrets.yaml` lives
# in the store too, any local user on the build host or the board could then
# decrypt that host's secrets. Instead `just sd-image <host>` injects the key into
# a non-store copy of the image after the build, at `/ssh-host-key` with mode 0600.
# The activation script below installs it to `/etc/ssh/ssh_host_ed25519_key` on
# first boot, before sops reads it.
{ nixpkgs }:
nixosConfig:
let
  inherit (nixpkgs) lib;
in
nixosConfig.extendModules {
  modules = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    {
      # The pinned Raspberry Pi kernel does not build the ZFS module (matches the
      # wiki's documented workaround for this exact module combination).
      boot.supportedFilesystems.zfs = lib.mkForce false;
      # sd-image-aarch64.nix sets this for a genuinely generic, any-hardware
      # installer image, pulling in a broad catch-all kernel module list — e.g.
      # dw-hdmi, which the Pi 5's vendor kernel doesn't build, breaking the module
      # closure. Not needed here: the nixos-hardware profile already declares
      # exactly what this specific, known board needs.
      hardware.enableAllHardware = lib.mkForce false;
    }

    (
      {
        config,
        options,
        pkgs,
        ...
      }:
      lib.mkMerge [
        {
          # Install the host key that `just sd-image` injected at /ssh-host-key
          # (see the header). Runs after `etc` so `/etc` exists; sops'
          # `setupSecrets` runs after this (below) and reads the key as its age
          # identity. A no-op on images built without a key (the board then
          # generates one on first boot).
          system.activationScripts.install-host-key = {
            deps = [ "etc" ];
            text = ''
              if [ -f /ssh-host-key ]; then
                mkdir -p /etc/ssh
                ${pkgs.coreutils}/bin/install -m 0600 -o root -g root /ssh-host-key /etc/ssh/ssh_host_ed25519_key
                rm -f /ssh-host-key
              fi
            '';
          };
        }
        # Only meaningful when the host actually has secrets configured;
        # `options ? sops` keeps hosts without the sops-nix module evaluating.
        (lib.mkIf (options ? sops && config.sops.secrets != { }) {
          system.activationScripts.setupSecrets.deps = [ "install-host-key" ];
        })
      ]
    )
  ];
}
