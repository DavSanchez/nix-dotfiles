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
      just
      just-lsp
      # protobuf

      zig
      zls
    ])
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.rr ];
}
