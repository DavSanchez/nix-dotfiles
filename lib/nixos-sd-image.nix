# Turns an existing nixosSystem output into a bootable, custom SD image for its board,
# per https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi#Custom_SD_image
#
# Usage:
#   let sdImageFor = import ./lib/nixos-sd-image.nix { inherit nixpkgs; };
#   in sdImageFor self.nixosConfigurations.mora
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

    # Optionally bake a pre-generated SSH host key into the image, so the board has
    # its sops age identity (derived from that key, see `sops.age.sshKeyPaths`) on the
    # very first boot instead of generating a key on first boot and only then having
    # it registered in `.sops.yaml`.
    #
    # The key is read from the git-ignored `local/host-keys/<host>.ed25519` dir, and
    # only when building impurely with `PI_HOST_KEYS_DIR=<abs dir> nix build --impure`
    # (which `just sd-image <host>` does when a key exists, after `just host-key
    # <host>`). Pure evaluation — every `nix flake check`, and any ordinary rebuild —
    # sees an empty `builtins.getEnv` and adds nothing.
    (
      {
        config,
        options,
        pkgs,
        ...
      }:
      let
        keysDir = builtins.getEnv "PI_HOST_KEYS_DIR";
        key =
          if keysDir == "" then
            null
          else
            builtins.readFile "${keysDir}/${config.networking.hostName}.ed25519";
        hostKeyFile = pkgs.writeText "ssh_host_ed25519_key" key;
      in
      lib.mkIf (key != null) (
        lib.mkMerge [
          {
            system.activationScripts.install-host-key =
              # Overwrites any key sshd generated on a previous boot, so re-flashing
              # keeps the same identity (and thus the same sops access).
              {
                text = ''
                  mkdir -p /etc/ssh
                  ${pkgs.coreutils}/bin/install -m 0600 -o root -g root ${hostKeyFile} /etc/ssh/ssh_host_ed25519_key
                '';
              };
          }
          # sops reads the host key during its activation script, so ours has to run
          # first. Only meaningful when the host actually has secrets configured;
          # `options ? sops` keeps hosts without the sops-nix module (e.g. bruma)
          # evaluating.
          (lib.mkIf (options ? sops && config.sops.secrets != { }) {
            system.activationScripts.setupSecrets.deps = [ "install-host-key" ];
          })
        ]
      )
    )
  ];
}
