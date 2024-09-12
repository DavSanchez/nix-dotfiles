{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      # cling
      # ccls

      # gnumake already defined in module top level
      # cmake
      # platformio
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      # Apple already provides these tools in its Command Line Tools
      # and some other toolchains expect them there, so conflicts often.
      # Add on-demand via Nix shells if required for Darwin.
      gcc

      # llvm
      lldb
    ];
}
