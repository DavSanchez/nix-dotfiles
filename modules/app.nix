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

    qutebrowser = {
      enable = true;
      loadAutoconfig = true;
      settings = {
        tabs = {
          show = "multiple";
          position = "left";
        };
        fonts = {
          default_family = config.fontProfiles.regular.family;
          default_size = "12pt";
        };
      };
      extraConfig = ''
        c.tabs.padding = {"bottom": 10, "left": 10, "right": 10, "top": 10}
      '';
    };
  };
}
