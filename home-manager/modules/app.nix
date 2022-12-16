{ config
, lib
, pkgs
, ...
}: {
  home.packages = with pkgs;
    [
      element-desktop
      lapce   # Code editor similar to VSCode
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

  programs = {
    kitty = {
      enable = true;
      settings = {
        # shell = "/bin/bash --login";
        font_family = "JetBrainsMono Nerd Font";
        font_size = 14;
      };
    };
  };
}
