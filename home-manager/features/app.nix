{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
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
      czkawka # Multi functional app to find duplicates, empty folders, similar images etc
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      # iterm2
      warp-terminal
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      zathura
    ];
}
