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

  ## Other packages
  home.packages =
    (with pkgs; [
      devenv
      devcontainer

      ## Other
      gnumake
      just
      just-lsp
      # protobuf
    ])
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.rr ];
}
