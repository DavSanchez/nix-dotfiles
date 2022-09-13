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
    ./rust.nix
  ];

  ## Other packages
  home.packages = with pkgs; [
    ## Shell
    shellcheck
    ## .NET
    # dotnet-sdk
    ## Other
    elixir
    python3
    unison-ucm
    zig
    ## Learning
    exercism
    ## Bazel
    bazelisk
    bazel-buildtools
  ];
}
