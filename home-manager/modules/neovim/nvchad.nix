{
  pkgs,
  ...
}: 
{
  programs.neovim = {
    extraPackages = with pkgs; [
      # NvChad prereqs
      ripgrep
      gcc
      # Fonts (already defined at user scope in fonts.nix)
      (nerdfonts.override {fonts = ["FiraCode" "Iosevka" "JetBrainsMono"];})
      fira-code-symbols
    ];
  };
  xdg.configFile.nvim = {
      source = (pkgs.nvchad.override { customConf = ./nvchad; });
      recursive = true;
  };
}
