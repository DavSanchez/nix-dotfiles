{ lib, pkgs, ... }:
{
  ## Main features
  imports = [
    ./c-cpp.nix
    ./devops.nix
    ./go.nix
    ./haskell
    # ./kafka.nix
    ./rust.nix
  ];

  ## Other packages
  home.packages =
    with pkgs;
    [
      devenv
      devcontainer

      ## Other
      gnumake
      # protobuf

      zig
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [ rr ];
}
