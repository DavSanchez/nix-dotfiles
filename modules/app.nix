{ pkgs, ... }:
{
  home.packages = with pkgs; [
    element-desktop
    # handbrake
    # logseq
    # gqrx
    # vlc
    # transmission
    # yacreader
    # zotero
    # insomnia
    # sonic-pi
    # mtr-gui
  ];
}
