{ config
, lib
, pkgs
, ...
}: {
  home.packages = with pkgs;
    [
      element-desktop
      lapce
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
    ];

  programs = {
    kitty = {
      enable = true;
      settings = {
        shell = "/bin/bash --login";
      };
    };
  };
}