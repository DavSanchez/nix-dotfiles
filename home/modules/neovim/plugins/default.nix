{
  barbar.enable = true;
  comment.enable = true;
  conform-nvim.enable = true;
  copilot-lua = {
    enable = true;
    settings = {
      suggestion.enabled = false;
      panel.enabled = false;
    };
  };
  dap.enable = true;
  direnv.enable = true;
  haskell-scope-highlighting.enable = true;
  lsp = {
    enable = true;
    servers = import ./lsp/servers.nix;
  };
  lualine.enable = true;
  luasnip.enable = true;
  multicursors.enable = true;
  neo-tree.enable = true;
  neogit.enable = true;
  neorg.enable = false;
  nix.enable = true;
  nix-develop.enable = true;
  nvim-autopairs.enable = true;
  cmp = {
    enable = true;
    settings = import ./cmp.nix;
  };
  cmp-path.enable = true;
  cmp-buffer.enable = true;
  cmp-cmdline.enable = true;
  cmp-conventionalcommits.enable = true;
  cmp-dap.enable = true;
  cmp-dictionary.enable = true;
  cmp_luasnip.enable = true;
  cmp-nvim-lsp.enable = true;
  copilot-cmp.enable = true;
  oil.enable = true;
  rustaceanvim.enable = true;
  telescope.enable = true;
  treesitter.enable = true;
  undotree.enable = true;
  which-key.enable = true;
  toggleterm.enable = true;
  web-devicons.enable = true;
}
