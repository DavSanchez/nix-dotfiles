# Shared Raspberry Pi bits, layered on top of a `nixos-hardware` board profile
# (raspberry-pi-3, raspberry-pi-5, ...).
#
# The board profile supplies the downstream Raspberry Pi kernel, the `config.txt`
# defaults and the extlinux + U-Boot boot path, but no disk layout. The system is
# installed from the *official* NixOS aarch64 SD image
# (<https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi_5>; on Hydra,
# `nixos.sd_image.aarch64-linux`, which is the installer flavour and ships the Pi 5
# boot files on unstable — 26.05 images do not), so this flake builds no image of
# its own and only has to match that image's layout.
{
  lib,
  ...
}:
{
  # Mirrors nixpkgs' sd-image module, which built the card this system was flashed
  # from: ext4 root labelled NIXOS_SD, FAT firmware partition labelled FIRMWARE.
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      # The firmware module below only refreshes the partition while it is mounted,
      # so it has to be in fstab (nofail keeps a bad card from blocking boot).
      options = [
        "nofail"
        "noatime"
      ];
    };
  };

  # Keep config.txt, the vendor device trees and U-Boot in step with the generation
  # being activated. The card came with the ones the official image was built with,
  # and U-Boot boots with the device tree the firmware loaded from this partition,
  # so they have to follow the kernel this configuration pins.
  #
  # Measured size of what it copies: ~26 MB of the stock 30 MB partition.
  hardware.raspberry-pi.firmware = {
    enable = true;
    uboot.enable = true;
  };

  # NixOS' systemd-initrd TPM2 support asks for tpm-crb/tpm-tis, and the trimmed
  # Raspberry Pi vendor kernels build neither, so the initrd's modules closure dies on
  # `modprobe: FATAL: Module tpm-crb not found`. There is no TPM2 on these boards, so
  # drop the support rather than paper over the missing modules (the Pi 3 profile's
  # allowMissing workaround, for a different module, is in nixos-hardware upstream).
  boot.initrd.systemd.tpm2.enable = false;
}
