{
  pkgs,
  lib,
  ...
}: {
  programs.neovim = {
    extraPackages = with pkgs; [
      # NvChad prereqs
      ripgrep
      gcc
      # Fonts (already defined at user scope in fonts.nix)
      (nerdfonts.override {fonts = ["FiraCode" "Iosevka" "JetBrainsMono"];})
      fira-code-symbols
    ];
    # Copilot plugin needs nodejs in PATH when using NvChad
    withNodeJs = true;
  };
  xdg.configFile."nvim" = {
    source = pkgs.fetchFromGitHub {
      owner = "nvchad";
      repo = "nvchad";
      rev = "d3d9aa251a9dd94881cdbc48c5852b3eaba969b8";
      hash = "sha256-PJm2zYIcRSHoEGG5IC1EPRzjkR9oyPZfId251YV/kXE=";
    };
    recursive = true;
  };
  xdg.configFile."nvim/lua/custom" = {
    source = ./nvchad;
    recursive = true;
  };
}
