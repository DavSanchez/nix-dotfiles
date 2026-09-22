# Turns an existing nixosSystem output into a bootable, custom SD image for its board,
# per https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi#Custom_SD_image
#
# Usage:
#   let sdImageFor = import ./lib/nixos-sd-image.nix { inherit nixpkgs; };
#   in sdImageFor self.nixosConfigurations.mora
{ nixpkgs }:

nixosConfig:
nixosConfig.extendModules {
  modules = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    {
      # The pinned Raspberry Pi kernel does not build the ZFS module (matches the
      # wiki's documented workaround for this exact module combination).
      boot.supportedFilesystems.zfs = nixpkgs.lib.mkForce false;
      # sd-image-aarch64.nix sets this for a genuinely generic, any-hardware
      # installer image, pulling in a broad catch-all kernel module list — e.g.
      # dw-hdmi, which the Pi 5's vendor kernel doesn't build, breaking the module
      # closure. Not needed here: the nixos-hardware profile already declares
      # exactly what this specific, known board needs.
      hardware.enableAllHardware = nixpkgs.lib.mkForce false;
    }
  ];
}
