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
    };
}
