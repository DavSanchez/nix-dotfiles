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
    source = pkgs.nvchad;
    recursive = true;
  };
  xdg.configFile."nvim/lua/custom" = {
    source = ./nvchad;
    recursive = true;
  };
}
