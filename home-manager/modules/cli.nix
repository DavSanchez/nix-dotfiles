{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      ## Nix
      rnix-lsp
      alejandra
      nix-prefetch-git
      nix-prefetch-github
      # nix-du # Build failing
      nix-output-monitor
      nix-update
      nix-diff
      statix
      # nox
      comma
      cachix
      # niv

      ## Utils
      coreutils
      # binutils # Clashes with GCC
      # pciutils

      ## Data visualzation/manipulation
      gawk
      gnused
      fx
      hexyl
      jo
      fq
      dasel
      difftastic

      ## Networking
      curl
      wget
      xh
      wrk
      mtr
      grpcurl
      termshark
      inetutils
      nmap

      # Searching/Movement helpers and other replacements
      ripgrep
      dua
      duf
      du-dust
      fd
      bat-extras.prettybat
      bat-extras.batman
      bat-extras.batgrep
      bat-extras.batdiff
      bat-extras.batwatch
      q # Replacing dogdns
      procs
      sd
      rm-improved
      gping
      bandwhich
      grex
      hyperfine
      tokei
      tre-command

      ## Other
      vale
      eva
      rmlint # Extremely fast tool to remove duplicates and other lint from your filesystem
      # chezmoi

      # System info
      neofetch

      ## Media
      imagemagick
      qrencode
      zbar # Barcode reading
      graphviz
      xdot
      ffmpeg

      ## Socials
      gomuks # Matrix client

      ## Security
      cotp
      # oath-toolkit

      ## Typesetting (with pygments for minted, pygmentex...)
      texlive.combined.scheme-full
      python310Packages.pygments

      haskellPackages.pandoc-crossref
      
      w3m
      
      jira-cli-go
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      m-cli
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
        # pager = "less -FR --mouse";
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    jq = {
      enable = true;
      colors = {
        null = "1;30";
        false = "0;31";
        true = "0;32";
        numbers = "0;36";
        strings = "0;33";
        arrays = "1;35";
        objects = "1;37";
      };
    };

    less.enable = true;

    # signature, passwords...
    gpg.enable = true;
    password-store.enable = true;

    broot = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    
    lf = {
      enable = true;
    };

    nnn = {
      enable = true;
      # package = pkgs.nnn.override ({ withNerdIcons = true; });
    };

    bottom.enable = true;

    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = true;
          use_pager = true;
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
    };
    
    pandoc.enable = true;
    yt-dlp.enable = true;
    feh.enable = true;

    nix-index = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    noti = {
      enable = true;
      # settings = { };
    };

    # TUI IRC client written in Rust.
    tiny = {
      enable = true;
      settings = {
        servers = [
          {
            addr = "irc.libera.chat";
            port = 6697;
            tls = true;
            realname = "David Sánchez";
            nicks = ["DavSanchez"];
          }
        ];
        defaults = {
          realname = "David Sánchez";
          nicks = ["DavSanchez"];
          join = [];
          tls = true;
        };
      };
    };

    topgrade = {
      enable = true;
      # settings = { };
    };

    watson = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    taskwarrior = {
      enable = true;
      # colorTheme = null;
      # config = {};
    };
  };
}
