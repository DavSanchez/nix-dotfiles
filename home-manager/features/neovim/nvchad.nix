{pkgs, ...}: let
  nvChad = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "699aeaa44203b62003da8aacd838a5bdac4c2d46";
    hash = "sha256-LldvBSROu3/pWqHb8OPbrsD3m0JbZFPyCPUk6AQoIKo=";
  };
in {
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
    source = nvChad;
    recursive = true;
  };
  xdg.configFile."nvim/lua/custom" = {
    source = ./nvchad;
    recursive = true;
  };
}
