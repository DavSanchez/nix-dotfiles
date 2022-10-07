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
    ./kafka.nix
    ./purescript.nix
    ./rust.nix
  ];

  ## Other packages
  home.packages = with pkgs;
    [
      ## Other Languages
      # dotnet-sdk
      # rPackages.rlang
      elixir
      python3
      unison-ucm
      zig
      ## Learning
      exercism
      ## Bazel
      bazelisk
      bazel-buildtools
      ## Other
      gnumake
      protobuf
      gdb
      # lldb # broken
      just # project-specific commands
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      rr
    ];
}
