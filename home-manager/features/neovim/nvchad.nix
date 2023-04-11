{
  pkgs,
  ...
}:
let
  nvChad = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "34bdca17d298c5762219649b238e8f1ca0689352";
    hash = "sha256-qpmq74JI775oocqLU/I5KetWrGF1KhwZlFjIgIonZ/Q=";
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
