{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      element-desktop
      sniffnet
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
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      # iterm2
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      zathura
      czkawka # Multi functional app to find duplicates, empty folders, similar images etc
    ];
}
