{
  pkgs,
  ...
}:
let
  nvChad = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "c77c086";
    sha256 = "sha256-3X10A9/poqfD43XlpwPA0nrf0WYZbsm0PymT5x1L7i0=";
  };
in 
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
  xdg.configFile."nvim" = {
      source = nvChad;
      recursive = true;
  };
  xdg.configFile."nvim/lua/custom" = {
      source = ./nvchad;
      recursive = true;
  };
}
