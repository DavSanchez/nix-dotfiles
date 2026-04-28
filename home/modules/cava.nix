{ pkgs, ... }:
{
  programs.cava = {
    enable = pkgs.stdenv.isLinux;
  };
}
