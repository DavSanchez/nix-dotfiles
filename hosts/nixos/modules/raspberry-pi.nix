# Shared Raspberry Pi bits, layered on top of a `nixos-hardware` board profile
# (raspberry-pi-3, raspberry-pi-5, ...), which supplies the downstream kernel and
# `config.txt`. Cards are flashed with a custom per-host SD image (`just sd-image
# <host>`, built via lib/nixos-sd-image.nix) that boots straight into this
# configuration, using the same NIXOS_SD/FIRMWARE labels as nixpkgs' own
# sd-image-aarch64.nix module.
{
  lib,
  ...
}:
{
  # Matches the image: ext4 root on NIXOS_SD, FAT firmware partition on FIRMWARE.
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      # The firmware module only refreshes the partition while it is mounted.
      options = [
        "nofail"
        "noatime"
      ];
    };
  };

  # U-Boot boots with the device tree the firmware loaded from this partition, so
  # config.txt, the DTBs and U-Boot have to follow the pinned kernel. Copies ~26 MB
  # into the stock 30 MB partition.
  hardware.raspberry-pi.firmware = {
    enable = true;
    uboot.enable = true;
  };

  # The Raspberry Pi vendor kernels build neither tpm-crb nor tpm-tis, which NixOS'
  # systemd-initrd TPM2 support asks for; these boards have no TPM2.
  boot.initrd.systemd.tpm2.enable = false;
}
