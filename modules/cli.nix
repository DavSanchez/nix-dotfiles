{ colorscheme, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # nix
    rnix-lsp
    nixpkgs-fmt
    nix-prefetch-git
    nix-prefetch-github
    nix-du
    nix-output-monitor

    # utils
    coreutils
    # binutils
    # pciutils
    gawk
    # arandr
    # bashmount
    # docker-compose
    dua
    fx
    gnumake
    gnused
    hexyl
    jo
    fq
    dasel
    curl
    wget
    xh
    wrk
    mtr
    grpcurl
    # ngrok
    # openvpn
    tokei
    # unrar
    # unzip
    termshark
    figlet
    protobuf
    inetutils

    # Moar colors
    # starship
    # zsh-syntax-highlighting

    # Searching/Movement helpers and other replacements
    # zoxide # See below
    # bat # See below
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

    vale
    eva
    chezmoi

    # system info
    neofetch

    # media
    imagemagick
    qrencode
    zbar
    graphviz
    xdot
    ffmpeg

    home-manager # Only the CLI

    gomuks # Matrix client

  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    m-cli
  ] ++ lib.optionals pkgs.stdenv.isLinux [

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
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head 200'" ];
      defaultCommand = "fd --type f";
      defaultOptions = [ "--height 40%" "--border" ];
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [ "--preview 'head {}'" ];
      historyWidgetOptions = [ "--sort" "--exact" ];
    };

    bat = {
      enable = true;
      config.theme = colorscheme.bat-theme-name;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zellij.enable = true;

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
          auto_update = false;
        };
      };
    };

    navi = {
      enable = true;
      enableZshIntegration = true;
    };

    nix-index = {
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
            nicks = [ "DavSanchez" ];
          }
        ];
        defaults = {
          realname = "David Sánchez";
          nicks = [ "DavSanchez" ];
          join = [ ];
          tls = true;
        };
      };
    };
  };
}
