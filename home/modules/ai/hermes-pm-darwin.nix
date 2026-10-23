# TEMPORARY — remove once NousResearch/hermes-agent#143410 is fixed upstream
# (fix in flight: NousResearch/hermes-agent#143332).
#
# hermes-agent afe3cbd8 switched the pm tool set (node, npm, uv, ripgrep, ...)
# from nixpkgs builds to the prebuilt artifacts pinned in pm/lock.json, packaged
# by nix/pm-packages.nix through autoPatchelfHook unconditionally. On darwin
# that hook runs during fixup against the Mach-O binaries of the darwin
# tarballs and aborts the build:
#
#   auto-patchelf: elftools.common.exceptions.ELFError: Magic number does not match
#   error: Cannot build '...-node-26.12.1.drv'
#
# and node takes hermes-tui, hermes-agent and the whole Home Manager generation
# down with it. Mach-O runs as shipped, so skip ELF patching for the pm set on
# darwin only — Linux keeps the upstream behaviour, and this file becomes a
# no-op once upstream lands the `isLinux` guard.
{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  # The module cannot branch on `pkgs` at the top level: Home Manager has to
  # evaluate the attribute set to collect `imports`/`options` before `pkgs`
  # exists, and doing so recurses. Branch on the option value instead.
  services.hermes-agent.package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
    inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      # Rebuild the pm tool set so `dontAutoPatchelf` lands on every derivation,
      # not just `node` — upstream skips the hook for the whole set as well.
      pmPackages = lib.mapAttrs (
        _: drv:
        drv.overrideAttrs (_: {
          dontAutoPatchelf = true;
        })
      ) (pkgs.callPackage "${inputs.hermes-agent}/nix/pm-packages.nix" { });
    }
  );
}
