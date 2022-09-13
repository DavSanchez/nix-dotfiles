{ pkgs, ... }:
{
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
  home.packages = with pkgs; [
    ## Shell
    shellcheck
    ## Other Languages
    elixir
    # dotnet-sdk
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
  ];
}
