{
  pkgs,
  ...
}: 
let
  nvChad = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "nvchad";
    version = "2.0";
    src = pkgs.fetchFromGitHub {
      owner = "NvChad";
      repo = "NvChad";
      rev = "bb87d70"; # v2.0
      sha256 = "1pfpyvgqw8ip153sj3nsv8a0hd267iqm7fizb526w2xg0b221ib7";
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
