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
  modifications = _final: prev: {
    # nixpkgs 319e4ceb bumped cargo-bundle to 0.12.0, which breaks zed-editor's
    # `cargo bundle` installPhase in two ways:
    #
    #   1. It moved the flat `osx_*` keys of `[package.metadata.bundle]` into an
    #      `osx` sub-table and now rejects the old spelling
    #      (`#[serde(deny_unknown_fields)]`), so Zed's crates/zed/Cargo.toml
    #      (still flat) fails with `unknown field osx_info_plist_exts`.
    #   2. It defaults to building both the `.app` and a `.dmg` on macOS
    #      (`settings.rs`: `[OsxBundle, OsxDmg]`); the `.dmg` shells out to
    #      `hdiutil`, which isn't available in the build sandbox.
    #
    # Translate the metadata into the shape 0.12.0 expects and request only the
    # `.app` until nixpkgs fixes zed-editor.
    #
    # Temporary: remove this override (and this comment) once the pinned nixpkgs
    # builds zed-editor again.
    zed-editor = prev.zed-editor.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        # nixpkgs' installPhase renames `bundle-stable` to `bundle` (the section
        # cargo-bundle reads), so only that section needs rewriting.
        sed -i '/^\[package.metadata.bundle-stable\]/,/^$/{
          /^osx_minimum_system_version =/d
          /^osx_info_plist_exts =/d
          /^osx_url_schemes =/d
        }' crates/zed/Cargo.toml
        cat >> crates/zed/Cargo.toml <<'EOF'

        [package.metadata.bundle.osx]
        minimum_system_version = "10.15.7"
        info_plist_exts = ["resources/info/*"]
        url_schemes = ["zed"]
        EOF
      '';
      # Ask cargo-bundle for the `.app` only; without this it also tries to
      # build a `.dmg`, which needs `hdiutil` (absent from the sandbox).
      installPhase =
        builtins.replaceStrings [ "cargo bundle --release" ] [ "cargo bundle --release --format osx" ]
          old.installPhase;
    });
  };
}
