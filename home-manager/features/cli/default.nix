{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./data.nix
    ./documents.nix
    ./multimedia.nix
    ./networking.nix
    ./nix.nix
    ./security.nix
    ./social.nix
    ./system.nix
    ./terminal.nix
  ];

  home.packages = with pkgs;
    [
      ## Utils
      coreutils
      # binutils # Already included with GCC
      pciutils

      w3m

      jira-cli-go
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      m-cli
    ];

  programs = {
    watson = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    taskwarrior = {
      enable = true;
      # colorTheme = null;
      # config = {};
    };
  };
}
