{ pkgs, ... }:
{
  imports = [
    ./ghostty # main
    # ./warp.nix
    # ./wezterm.nix
    # ./rio.nix
  ];

  home.packages = [ pkgs.cmux ];
}
