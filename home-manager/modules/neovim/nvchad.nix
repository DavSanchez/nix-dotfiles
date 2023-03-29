{
  pkgs,
  ...
}: 
let
  # Taken from https://github.com/azuwis/nix-config/blob/master/common/neovim/nvchad.nix
  nvChad = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "nvchad";
    version = "2.0";
    src = pkgs.fetchFromGitHub {
      owner = "NvChad";
      repo = "NvChad";
      rev = "c77c086"; # v2.0
      sha256 = "sha256-3X10A9/poqfD43XlpwPA0nrf0WYZbsm0PymT5x1L7i0=";
    };
    meta.homepage = "https://github.com/NvChad/NvChad/";
  };
in
{
  programs.neovim = {
    plugins = [ nvChad ];
    extraPackages = with pkgs; [
      # NvChad prereqs
      ripgrep
      gcc
      # Fonts (already defined at user scope in fonts.nix)
      (nerdfonts.override {fonts = ["FiraCode" "Iosevka" "JetBrainsMono"];})
      fira-code-symbols
    ];
  };
  xdg.configFile."nvim/init.lua".text = ''
    vim.cmd [[source ${nvChad}/init.lua]]
  '';
  xdg.configFile."nvim/lua/custom".source = ./nvchad;
  # xdg.configFile."nvim/lua/telescope".source = ./telescope;
}
