{
  pkgs,
  ...
}: 
{
  imports = [
    ./nvchad.nix
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      alejandra
      nil
      lua-language-server
      stylua
    ];
    plugins = with pkgs.vimPlugins; [
      vim-nix
      nvim-treesitter.withAllGrammars
    ];
    withNodeJs = false;
    withRuby = false;
  };
}
