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
    less
    # arandr
    # bashmount
    # docker-compose
    dua
    fx
    gnumake
    gnused
    hexyl
    jo
    jq
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
    navi
    inetutils

    # Moar colors
    # starship
    # zsh-syntax-highlighting

    # Searching/Movement helpers and other replacements
    # zoxide # See below
    # bat # See below
    ripgrep
    broot
    lsd
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

    pandoc
    vale
    eva
    chezmoi

    # system info
    neofetch

    # media
    feh
    imagemagick
    qrencode
    zbar
    graphviz
    xdot
    ffmpeg
    yt-dlp

    home-manager # Only the CLI

  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    m-cli
  ];

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    bat = {
      enable = true;
      config.theme = colorscheme.bat-theme-name;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zellij = {
      enable = true;
    };

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
