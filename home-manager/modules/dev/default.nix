{
  lib,
  pkgs,
  ...
}: {
  ## Main features
  imports = [
    ./c-cpp.nix
    ./devops.nix
    ./digital-design.nix
    ./go.nix
    ./haskell
    ./java.nix
    # ./kafka.nix
    # ./purescript.nix
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
  
      ## Other
      gnumake
      protobuf
      rosetta.gdb # Using Rosetta
      lldb
      just # project-specific commands
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      rr
    ];
}
