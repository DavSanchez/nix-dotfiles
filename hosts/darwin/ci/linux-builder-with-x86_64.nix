# CI-specific nix-darwin configuration that upgrades the Linux builder to also
# support x86_64-linux via QEMU binfmt emulation inside the NixOS VM.
#
# This requires a prior linux-builder bootstrap (aarch64-linux only) to be running
# first — see `linux-builder-bootstrap.nix`.
#
# This module imports the bootstrap config and only overrides the options that
# differ: the systems list and binfmt emulated systems.

{ lib, ... }:

{
  imports = [ ./linux-builder-bootstrap.nix ];

  nix.linux-builder.systems = lib.mkForce [
    "x86_64-linux"
    "aarch64-linux"
  ];

  nix.linux-builder.config = {
    boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
    virtualisation.darwin-builder.memorySize = lib.mkForce 4096;
    nix.settings.max-jobs = 1;
    nix.settings.cores = 1;
  };
}
