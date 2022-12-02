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
      nix-du
      nix-output-monitor
      nix-update
      nix-diff
      statix
      nox
      comma
      cachix
      niv

      ## Utils
      coreutils
      # binutils
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
      fd
      bat-extras.prettybat
      bat-extras.batman
      bat-extras.batgrep
      bat-extras.batdiff
      bat-extras.batwatch
      dogdns
      procs
      sd
      rm-improved
      gping
      bandwhich
      grex
      hyperfine
      tokei

      ## Other
      vale
      eva
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
      # oath-toolkit

      ## Typesetting (with pygments for minted, pygmentex...)
      texlive.combined.scheme-full
      python310Packages.pygments

      haskellPackages.pandoc-crossref
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
    };
    
    lf = {
      enable = true;
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
    };

    pandoc.enable = true;
    yt-dlp.enable = true;
    feh.enable = true;

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
    };

    taskwarrior = {
      enable = true;
      # colorTheme = null;
      # config = {};
    };
  };
}
