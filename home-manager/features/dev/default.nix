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
      devenv
      devcontainer

      ## Other
      gnumake
      # protobuf
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      rr
    ];
}
