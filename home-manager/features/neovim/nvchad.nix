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
      owner = "NvChad";
      repo = "NvChad";
      rev = "0e27cb4b44fbba69f8646d1f88555737d2b6aedf";
      hash = "sha256-nEQ36jj5hHIpg+NYWeAEroHMI6mRdKCaWDbXXr/iRAE=";
    };
    recursive = true;
  };
  xdg.configFile."nvim/lua/custom" = {
    source = ./nvchad;
    recursive = true;
  };
}
