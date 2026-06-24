{ pkgs, ... }:
{
  imports = [
    ./ghostty # main
    ./rio.nix
    ./warp.nix
    # ./wezterm.nix
  ];
}
