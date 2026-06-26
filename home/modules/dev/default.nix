{ lib, pkgs, ... }:
{
  ## Main features
  imports = [
    ./c-cpp.nix
    ./devops.nix
    ./digital-design.nix
    ./formal.nix
    ./fp.nix
    ./go.nix
    ./haskell.nix
    # ./java.nix
    # ./kafka.nix
    ./rust.nix
    ./api.nix
    ./python.nix
  ];

  programs.devenv.enable = true;

  ## Other packages
  home.packages =
    (with pkgs; [
      gnumake
      just
      just-lsp
      # protobuf
    ])
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.rr ];
}
