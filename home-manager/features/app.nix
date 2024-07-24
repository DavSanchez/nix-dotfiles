{ lib, pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      # element-desktop
      # sniffnet
      # contour # broken
      # lapce
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
      # czkawka # Multi functional app to find duplicates, empty folders, similar images etc
      zathura
    ])
    ++ lib.optionals pkgs.stdenv.isDarwin [ pkgs.utm pkgs.ollama ]
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.imhex ];
}
