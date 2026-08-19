{ pkgs, ... }:
{
  programs.cava = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
  };
}
