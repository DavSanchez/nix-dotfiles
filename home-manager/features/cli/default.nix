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
      uutils-coreutils
      binutils
      pciutils

      w3m

      tlrc
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [ m-cli ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      elfutils
      # patchelf # present in ./nix.nix
    ];

  services.tldr-update.enable = true;
}
