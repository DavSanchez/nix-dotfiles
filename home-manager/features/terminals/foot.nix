{ pkgs, ... }:
{
  programs.foot = {
    enable = pkgs.stdenv.isLinux;
  };
}
