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

      ## Learning
      exercism

      # devenv.sh, let's work with any language!
      devenv

      idris2 # not in devenv yet!
      agda # not in devenv yet!

      ## Other
      gnumake
      # protobuf
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      rr
    ];
}
