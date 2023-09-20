{pkgs, ...}: {
  home.packages = with pkgs;
    [
      nixd # Language server
      alejandra # Formatter
      nix-bundle
      nix-output-monitor
      nix-update
      nix-diff
      statix # Lints and suggestions for Nix
      comma # Runs programs without installing them
      cachix
      nurl
      nix-init # Nix derivation boilerplate
      deadnix # Scan Nix files for dead code
      vulnix # Vulnerability (CVE) scanner for Nix
      nix-tree # Interactively browse a Nix store paths dependencies
      # nix-du # Visualize gc-roots
      nix-melt # Ranger for flake.lock

      # Binary management
      patchelf
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      nix-ld
    ];

  programs = {
    nix-index = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };
}
