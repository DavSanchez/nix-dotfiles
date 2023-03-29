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
    # ./kafka.nix
    ./rust.nix
  ];

  ## Other packages
  home.packages = with pkgs;
    [
      taplo # TOML Langserver
      nodePackages.yaml-language-server # Langserver

      ## Other
      gnumake
      just # project-specific commands
      protobuf

      # devenv.sh
      devenv
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      rr
    ];
}
