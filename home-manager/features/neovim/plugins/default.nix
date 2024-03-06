{
  barbar.enable = true;
  chadtree.enable = true;
  codeium-nvim.enable = true;
  comment-nvim = {
    enable = true;
    toggler.line = "<leader>/";
  };
  dap.enable = true;
  haskell-scope-highlighting.enable = true;
  lsp = {
    enable = true;
    servers = import ./lsp/servers.nix;
  };
  lualine.enable = true;
  luasnip.enable = false;
  multicursors.enable = true;
  neogit.enable = true;
  neorg.enable = true;
  nix.enable = true;
  nix-develop.enable = true;
  nvim-autopairs.enable = true;
  cmp.enable = true;
  oil.enable = true;
  rustaceanvim.enable = true;
  telescope.enable = true;
  treesitter.enable = true;
  undotree.enable = true;
  which-key.enable = true;
}
