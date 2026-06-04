# CI-specific nix-darwin configuration for testing the Linux builder on GitHub Actions.
#
# This configuration is used by `.github/workflows/nix-darwin.yml` to bootstrap
# a Linux builder VM before building the actual nix-darwin configurations.
#
# ## QEMU HVF Workaround
#
# On GitHub Actions macOS runners, QEMU crashes with SIGABRT when attempting to
# use Apple's Hypervisor.framework (HVF) for hardware-accelerated virtualization.
# The crash occurs because:
#
# 1. The nixpkgs `qemu-common.nix` generates QEMU invocations with
#    `-machine virt,gic-version=2,accel=hvf:tcg` for aarch64-darwin hosts
#    (see: https://github.com/Mic92/nixpkgs/blob/8c69eeeb3d38b4b53c5b990436fb9ec4574b05c6/nixos/lib/qemu-common.nix#L53)
#
# 2. The `accel=hvf:tcg` syntax means "try HVF, fall back to TCG if unavailable"
#
# 3. However, QEMU's `hvf_accel_init` calls `abort()` when `hvf_arm_get_max_ipa_bit_size`
#    fails, instead of gracefully falling back to TCG. This is a QEMU bug
#    (see https://gitlab.com/qemu-project/qemu/-/work_items/2981).
#
# 4. GitHub Actions macOS runners are themselves VMs and may not fully support
#    nested virtualization via HVF, triggering this crash path.
#
# The workaround below creates a wrapper around `qemu-system-aarch64` that rewrites
# the `-machine` argument at runtime, replacing `accel=hvf:tcg` with `accel=tcg`
# to force software emulation (TCG) and avoid the HVF crash.
#
# This wrapper is set as the QEMU package via `virtualisation.qemu.package` in the
# linux-builder's NixOS configuration.

{ pkgs, inputs, ... }:

let
  realQemu = pkgs.stable.qemu;

  # Wrapper that forces TCG (software emulation) by rewriting QEMU's -machine argument.
  # This avoids the HVF crash on GitHub Actions runners while maintaining compatibility
  # with the nixpkgs-generated QEMU invocation.
  qemuTCG = pkgs.stable.runCommand "qemu-tcg" { } ''
    mkdir -p $out/bin
    ln -s ${realQemu}/bin/* $out/bin/
    rm $out/bin/qemu-system-aarch64
    cat > $out/bin/qemu-system-aarch64 << 'EOF'
    #!/bin/bash
    args=()
    for arg in "$@"; do
      case "$arg" in
        *accel=hvf*)
          arg=$(printf '%s' "$arg" | sed 's/accel=hvf:tcg/accel=tcg/;s/accel=hvf/accel=tcg/')
          ;;
      esac
      args+=("$arg")
    done
    exec ${realQemu}/bin/qemu-system-aarch64 "''${args[@]}"
    EOF
    chmod +x $out/bin/qemu-system-aarch64
  '';
in
{
  nixpkgs.overlays = [ inputs.self.overlays.stable-packages ];
  nix.settings.experimental-features = "nix-command flakes";

  nix.linux-builder = {
    enable = true;
    package = pkgs.stable.darwin.linux-builder;
    ephemeral = true;
    systems = [ "aarch64-linux" ];
    config.virtualisation.qemu.package = qemuTCG;
  };

  system.stateVersion = 6;
  system.primaryUser = "runner";
}
