{ config, pkgs, ... }:

{
  home = {
    packages = [ pkgs.rustup ];
  };
}
