{ pkgs, ... }:
{
  home.sessionVariables = {
    # Colored man pages via bat (fish had `colored-man-pages`); nu sets this in its own env
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  home.packages = with pkgs; [
    # Searching/Movement helpers and other replacements
    dua
    duf
    fd
    sd
    rm-improved
    hyperfine
    tokei
    erdtree # File-tree visualizer and disk usage analyzer
    cyme # modern lsusb
    fend
    viddy

    ## Other
    rmlint # Extremely fast tool to remove duplicates and other lint from your filesystem
    watchexec
  ];

  programs = {
    ripgrep.enable = true;

    eza = {
      enable = true;
      git = true;
      icons = "auto";
      colors = "auto";
    };

    television.enable = true;

    nix-search-tv = {
      enable = true;
      settings = {
        indexes = [
          "nixpkgs"
          "home-manager"
          "nixos"
          "darwin"
          "nur"
          "noogle"
        ];
      };
    };

    fzf = {
      enable = false;
      changeDirWidget = {
        command = "fd --type d";
        options = [ "--preview 'tree -C {} | head 200'" ];
      };
      defaultCommand = "fd --type f";
      defaultOptions = [
        "--height 40%"
        "--border"
      ];
      # fileWidgetCommand = "fd --type f";
      # fileWidgetOptions = [ "--preview 'bat --color=always --style=numbers --line-range=:500 {}'" ];
      historyWidget.options = [
        "--sort"
        "--exact"
      ];
      tmux.shellIntegrationOptions = [ "-d 40%" ];
    };

    bat = {
      enable = true;
      config = {
        # theme = "TwoDark";
        # add --mouse below to enable mouse inside tmux,
        # but text selection will be disabled unless:
        # - You press shift (not copy-mode)
        # - Enter copy-mode with C-b + [
        pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen";
      };
      extraPackages = with pkgs.bat-extras; [
        prettybat
        batman
        batgrep
        batdiff
        batwatch
      ];
    };

    zoxide.enable = true;

    less.enable = true;

    xplr.enable = true;

    lf.enable = true;

    tealdeer = {
      enable = false; # Using tlrc
      settings = {
        updates = {
          auto_update = true;
        };
      };
    };

    navi.enable = true;

    carapace.enable = true;
  };
}
