{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    nixd # Language server
    nil # another LS
    nixfmt # Nix formatter
    nix-bundle
    nix-inspect
    nix-output-monitor
    nix-update
    nix-diff
    # TODO: Remove this override once `dix` releases a new version
    (dix.overrideAttrs (prev: {
      checkFlags =
        prev.checkFlags
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          "--skip=store::test_utils::tests::test_circular_dependencies"
          "--skip=store::test_utils::tests::test_db_query_closure_path_info"
          "--skip=store::test_utils::tests::test_db_query_closure_size"
          "--skip=store::test_utils::tests::test_db_query_dependents"
          "--skip=store::test_utils::tests::test_db_query_system_derivations"
          "--skip=store::test_utils::tests::test_deep_chain"
          "--skip=store::test_utils::tests::test_self_referential_path"
          "--skip=store::test_utils::tests::test_wide_tree"
          "--skip=tests::test_path_to_canonical_string_basic"
          "--skip=tests::test_path_to_canonical_string_invalid_unicode"
          "--skip=tests::test_path_to_canonical_string_with_symlink"
          "--skip=version::tests::test_version_transitivity"
        ];
    }))
    # statix # Lints and suggestions for Nix
    comma # Runs programs without installing them
    cachix
    nurl
    nix-init # Nix derivation boilerplate
    # deadnix # Scan Nix files for dead code
    # vulnix # Vulnerability (CVE) scanner for Nix
    nix-tree # Interactively browse a Nix store paths dependencies
    # nix-du # Visualize gc-roots
    nix-melt # Ranger for flake.lock

    # Binary management
    patchelf
  ];

  programs = {
    nix-index.enable = true;

    nix-your-shell.enable = true;

    nh = {
      enable = true;
      clean.enable = true;
      flake = toString (lib.path.append (/. + config.home.homeDirectory) ".dotfiles");
    };
  };
}
