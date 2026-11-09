# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  # rosetta-packages = final: _prev: {
  #   rosetta = if final.stdenv.hostPlatform.isDarwin && final.stdenv.isAarch64 then final.pkgsx86_64Darwin else final;
  # };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications =
    _final: prev:
    let
      tv = prev.television;

      # Last television version reviewed for the nushell/Helix patch below.
      # alexpasmantier/television#1134 is merged upstream but unreleased as of
      # 0.15.9, so any version bump needs a manual look.
      reviewedTelevision = "0.15.9";

      # opencode 2.2.5 (nixpkgs 6dadaf4) carries a node_modules hash computed
      # while nixpkgs still had bun 1.4.2. bun 1.4.4 filters optional
      # dependencies by host libc, so that fixed-output derivation never
      # matches on any host. Carry the per-platform rehash from
      # https://github.com/NixOS/nixpkgs/pull/582675 (merged publicly, not in
      # the pinned nixpkgs yet). The guard is the broken hash itself; once
      # nixpkgs ships the fixed hash (or moves past 2.2.5) the override throws
      # instead of lingering silently, so it gets removed on the next bump.
      brokenOpencodeNodeModulesHash = "sha256-xfOVcw1+waLVNhFDwzOtzxrUSQEogvn88YomydOlhwc=";
    in
    {
      television =
        if tv.version == reviewedTelevision then
          tv.overrideAttrs (old: {
            # nushell 0.115+ gives Helix edit mode its own keybinding tables, so
            # `tv init nu` must bind tv_smart_autocomplete/tv_shell_history for
            # helix_normal/helix_insert/helix_select too. --replace-fail is the
            # tripwire: it aborts the build once upstream ships the fix (or
            # refactors that line), instead of silently patching nothing.
            postPatch = (old.postPatch or "") + ''
              substituteInPlace television/utils/shell/completion.nu \
                --replace-fail 'mode: [vi_normal, vi_insert, emacs],' \
                               'mode: [vi_normal, vi_insert, emacs, helix_normal, helix_insert, helix_select],'
            '';
          })
        else
          throw ''
            television is now ${tv.version}; last reviewed: ${reviewedTelevision}.

            Check whether it already carries the nushell Helix-mode fix
            (alexpasmantier/television#1134):

              curl -sL https://raw.githubusercontent.com/alexpasmantier/television/${tv.version}/television/utils/shell/completion.nu | grep helix

            - If it does: delete the television override in overlays/default.nix.
            - If it doesn't: bump reviewedTelevision to "${tv.version}" and keep the patch.
          '';

      opencode =
        if (prev.opencode.node_modules.outputHash or null) == brokenOpencodeNodeModulesHash then
          prev.opencode.overrideAttrs (old: {
            node_modules = old.node_modules.overrideAttrs (_: {
              outputHash =
                if prev.stdenv.hostPlatform.isLinux then
                  "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA="
                else
                  "sha256-dIveiaiPFGSItwLyeMuPDxTE9gpvvnlTCB/+nG24qCc=";
            });
          })
        else if prev.lib.versionAtLeast prev.opencode.version "2.2.5" then
          throw ''
            opencode ${prev.opencode.version} no longer carries the broken
            node_modules hash this overlay patches (NixOS/nixpkgs#582675).

            Delete the `opencode` override and `brokenOpencodeNodeModulesHash`
            from overlays/default.nix.
          ''
        else
          prev.opencode;
    };
}
