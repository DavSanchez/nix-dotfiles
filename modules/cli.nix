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
      nox
      comma
      cachix

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

      ## Networking
      curl
      wget
      xh
      wrk
      mtr
      grpcurl
      termshark
      inetutils

      # Searching/Movement helpers and other replacements
      ripgrep
      dua
      fd
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

      ## Organization/management
      watson

      # home-manager # CLI (disabled, clashes with topgrade)
      nix # Nix itself

      ## Socials
      gomuks # Matrix client

      ## Security
      oath-toolkit
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
      fileWidgetOptions = ["--preview 'head {}'"];
      historyWidgetOptions = ["--sort" "--exact"];
      tmux.enableShellIntegration = true;
      tmux.shellIntegrationOptions = ["-d 40%"];
    };

    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        pager = "less -FR --mouse";
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

    bottom.enable = true;

    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
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
  };
}
