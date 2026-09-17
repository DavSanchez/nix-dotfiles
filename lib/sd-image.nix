# Builds the *official* NixOS aarch64 SD-card image from this flake's pinned nixpkgs —
# the same module behind Hydra's `nixos.sd_image.aarch64-linux` job — so a card can be
# produced locally instead of downloaded.
#
# It is the installer flavour: root/nixos with empty passwords, sshd on, NetworkManager,
# console autologin, and no host-specific configuration. The Raspberry Pi hosts are then
# deployed onto it (see hosts/nixos/modules/raspberry-pi.nix), which is why nothing here
# imports them or nixos-hardware.
#
# `just sd-image` builds this; `just flash-image <printed path> <disk>` writes it.
let
  nixpkgs = (builtins.getFlake (toString ./..)).inputs.nixpkgs;
in
(nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  modules = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
    # What nixos/release.nix's makeModules does for the Hydra job, so this image matches
    # it instead of warning about a missing state version.
    ({ config, ... }: {
      system.stateVersion = config.system.nixos.release;
    })
  ];
}).config.system.build.sdImage
