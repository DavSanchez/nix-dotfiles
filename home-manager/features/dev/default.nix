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

      ## Other
      gnumake
      # protobuf

      grcov # code coverage
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      rr
    ];
}
