{ lib, pkgs, ... }:
{
  imports = [
    ./data.nix
    ./documents.nix
    ./multimedia.nix
    ./navigation.nix
    ./networking.nix
    ./nix.nix
    ./security.nix
    ./social.nix
    ./system.nix
    ./terminal.nix
  ];

  home.packages =
    with pkgs;
    [
      ## Utils
      coreutils
      # binutils # Already included with pkgs.gcc
      pciutils

      w3m
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [ m-cli ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      elfutils
      # patchelf # present in ./nix.nix
    ];

  programs = {
    watson = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    taskwarrior = {
      enable = false;
      # colorTheme = null;
      # config = {};
    };
  };
}
