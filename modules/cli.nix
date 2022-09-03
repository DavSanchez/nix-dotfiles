{ colorscheme, pkgs, ... }:

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
    jq
    fq
    curl
    wget
    xh
    # ngrok
    # openvpn
    tokei
    # unrar
    # unzip
    termshark
    figlet
    protobuf
    tealdeer
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

    pass

    # system info
    neofetch

    # media
    feh
    imagemagick
    qrencode
    zbar
    graphviz
    ffmpeg
    yt-dlp
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config.theme = colorscheme.bat-theme-name;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zellij = {
    enable = true;
  };

  # signature, passwords...
  programs.gpg.enable = true;
  programs.password-store.enable = true;

  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bottom.enable = true;
}
