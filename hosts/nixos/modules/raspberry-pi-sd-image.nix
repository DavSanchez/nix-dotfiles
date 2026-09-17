# Shared Raspberry Pi bits, layered on top of a `nixos-hardware` board profile
# (raspberry-pi-3, raspberry-pi-5, ...).
#
# The board profiles deliberately do not define a disk layout: they only select
# the downstream Raspberry Pi kernel, the `config.txt` defaults and the
# extlinux + U-Boot boot path. This module adds the other half of the recipe from
# <https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi>: the generic aarch64
# SD-card image module, so one configuration both builds the image that gets
# flashed onto the card and serves as the `deploy-rs` target for later switches.
{
  inputs,
  lib,
  ...
}:
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  # profiles/base.nix (pulled in by the SD image module) defaults ZFS to enabled
  # when the platform looks like it supports it, but the pinned Raspberry Pi
  # kernel has no out-of-tree ZFS module to build.
  boot.supportedFilesystems.zfs = lib.mkForce false;

  # sd-image.nix mounts /boot/firmware with noauto/nofail, and the firmware
  # module below only refreshes the partition while it is mounted, so mount it
  # at boot (still non-fatal).
  fileSystems."/boot/firmware".options = lib.mkForce [
    "nofail"
    "noatime"
  ];

  # The image ships an already-populated firmware partition (the firmware module
  # overrides sdImage.populateFirmwareCommands). On a running system this keeps
  # config.txt, the board device trees and U-Boot in sync with the generation
  # being activated, so a kernel bumped by nixos-hardware also refreshes the
  # files the GPU firmware loads before Linux starts.
  hardware.raspberry-pi.firmware = {
    enable = true;
    uboot.enable = true;
  };
}
