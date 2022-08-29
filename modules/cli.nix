{ colorscheme, pkgs, ... }:

{
  home.packages = with pkgs; [
    # nix
    rnix-lsp
    nixpkgs-fmt
    nix-prefetch-git
    nix-prefetch-github
    nix-du

    # utils
    coreutils
    binutils
    pciutils
    gawk
    arandr
    bashmount
    dig
    # docker-compose
    dua
    fx
    gnumake
    gnused
    hexyl
    jo
    jq
    curl
    wget
    xh
    # ngrok
    # openvpn
    tokei
    # unrar
    # unzip
    # wireshark
    figlet
    protobuf

    # Moar colors
    starship
    zsh-syntax-highlighting

    # Searching/Movement helpers and other replacements
    ripgrep
    # zoxide # See below
    # bat # See below
    broot
    lsd
    dua
    fd

    # system info
    bottom
    neofetch

    # media
    feh
    tty-clock
    imagemagick
    qrencode
    zbar
    graphviz
    ffmpeg

    minikube
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
}
