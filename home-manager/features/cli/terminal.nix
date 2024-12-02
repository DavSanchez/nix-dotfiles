{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Searching/Movement helpers and other replacements
    dua
    duf
    du-dust
    fd
    sd
    rm-improved
    hyperfine
    tokei
    erdtree # File-tree visualizer and disk usage analyzer

    ## Other
    rmlint # Extremely fast tool to remove duplicates and other lint from your filesystem
  ];

  programs = {
    ripgrep.enable = true;

    eza = {
      enable = true;
      git = true;
      icons = "auto";
      colors = "auto";
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head 200'" ];
      defaultCommand = "fd --type f";
      defaultOptions = [
        "--height 40%"
        "--border"
      ];
      # fileWidgetCommand = "fd --type f";
      # fileWidgetOptions = [ "--preview 'bat --color=always --style=numbers --line-range=:500 {}'" ];
      historyWidgetOptions = [
        "--sort"
        "--exact"
      ];
      tmux.enableShellIntegration = true;
      tmux.shellIntegrationOptions = [ "-d 40%" ];
    };

    bat = {
      enable = true;
      config = {
        # theme = "TwoDark";
        # add --mouse below to enable mouse inside tmux,
        # but text selection will be disabled unless:
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

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    less.enable = true;

    xplr = {
      enable = true;
      extraConfig = "";
      plugins = { };
    };

    lf = {
      enable = true;
    };

    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = true;
          # use_pager = true;
        };
        updates = {
          auto_update = true;
        };
      };
    };

    navi = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      # settings = {
      #   inline_height = 40;
      # };
    };

    carapace = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
