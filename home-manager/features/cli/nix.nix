{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    nixd # Language server
    nixfmt-rfc-style # Nix formatter
    nix-bundle
    nix-inspect
    nix-output-monitor
    nix-update
    nix-diff
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
      flake = builtins.toString (lib.path.append (/. + config.home.homeDirectory) ".dotfiles");
    };
  };
}
