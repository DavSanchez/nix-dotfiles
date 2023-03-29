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
      lua-language-server
      rnix-lsp
      stylua
      (tree-sitter.withPlugins (_: tree-sitter.allGrammars))
    ];
    plugins = with pkgs.vimPlugins; [
      vim-nix
      # nvim-treesitter.withAllGrammars
      copilot-vim
    ];
  };
}
