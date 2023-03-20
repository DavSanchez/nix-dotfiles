{
  lib,
  pkgs,
  ...
}: {
  ## Main features
  imports = [
    ./c-cpp.nix
    ./devops.nix
    ./go.nix
    ./haskell
    ./java.nix
    # ./kafka.nix
    ./rust.nix
  ];

  ## Other packages
  home.packages = with pkgs;
    [
      ## Other Languages
      elixir
      elixir_ls # Langserver

      python3

      taplo # TOML Langserver
      nodePackages.yaml-language-server # Langserver

      ## Other
      gnumake
      protobuf
      gdb # Using Rosetta
      lldb
      just # project-specific commands

      # devenv
      devenv
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      rr
    ];
}
