{
  lib,
  pkgs,
  ...
}: {
  ## Main features
  imports = [
    ./c-cpp.nix
    ./devops.nix
    # ./digital-design.nix
    # ./fp.nix
    ./go.nix
    ./haskell
    ./java.nix
    # ./kafka.nix
    ./rust.nix
  ];

  ## Other packages
  home.packages = with pkgs;
    [
      taplo # TOML Langserver
      nodePackages.yaml-language-server # Langserver

      # devenv.sh, let's work with any language!
      devenv

      ## Other
      gnumake
      # protobuf

      grcov # code coverage
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      rr
    ];
}
