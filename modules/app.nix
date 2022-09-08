{ pkgs, lib, ... }:
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
  ] ++ lib.optionals stdenv.isDarwin [
    pkgs.iterm2
  ];
}
