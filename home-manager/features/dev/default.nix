{ lib, pkgs, ... }:
{
  ## Main features
  imports = [
    ./c-cpp.nix
    ./devops.nix
    ./digital-design.nix
    ./fp.nix
    ./go.nix
    ./haskell
    ./java.nix
    # ./kafka.nix
    ./rust.nix
  ];

  ## Other packages
  home.packages =
    (with pkgs; [
      devenv

      ## Other
      gnumake
      # protobuf

      zig
      zls

      # A command runner
      just
    ])
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.rr ];
}
