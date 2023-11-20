{pkgs, ...}: {
  home.packages = with pkgs; [
    # Searching/Movement helpers and other replacements
    ripgrep
    dua
    duf
    du-dust
    fd
    sd
    rm-improved
    hyperfine
    tokei
    tre-command
    erdtree # File-tree visualizer and disk usage analyzer

    ## Other
    eva
    rmlint # Extremely fast tool to remove duplicates and other lint from your filesystem

    ## For use with Yazi
    ffmpegthumbnailer
    unar
    jq
    poppler
    ripgrep
    fzf
    zoxide
  ];

  programs = {
    lsd = {
      enable = true;
      enableAliases = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = ["--preview 'tree -C {} | head 200'"];
      defaultCommand = "fd --type f";
      defaultOptions = ["--height 40%" "--border"];
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = ["--preview 'bat --color=always --style=numbers --line-range=:500 {}'"];
      historyWidgetOptions = ["--sort" "--exact"];
      tmux.enableShellIntegration = true;
      tmux.shellIntegrationOptions = ["-d 40%"];
    };

    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
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
    };

    less.enable = true;

    broot = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings.verbs = [
        {
          invocation = "custom_panel_right";
          key = "shift-right";
          execution = ":panel_right";
        }
        {
          invocation = "custom_panel_left";
          key = "shift-left";
          execution = ":panel_left";
        }
      ];
    };

    xplr = {
      enable = true;
      extraConfig = "";
      plugins = [];
    };

    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      keymap = { };
      settings = { };
      theme = { };
    };

    lf = {
      enable = true;
    };

    nnn = {
      enable = true;
      package = pkgs.nnn.override {withNerdIcons = true;};
      extraPackages = with pkgs;
        [
          ffmpegthumbnailer
          mediainfo
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          sxiv
        ];
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
      # enableZshIntegration = true;
      # enableBashIntegration = true;
      # enableFishIntegration = true;
      # enableNuIntegration = true;
      settings = {
        inline_height = 40;
      };
    };
  };
}
