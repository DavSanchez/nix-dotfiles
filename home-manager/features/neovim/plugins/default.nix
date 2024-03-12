{
  barbar.enable = true;
  chadtree.enable = true;
  codeium-nvim.enable = true;
  comment-nvim.enable = true;
  copilot-vim.enable = true;
  dap.enable = true;
  direnv.enable = true;
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
  cmp = {
    enable = true;
    settings = {
      mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-e>" = "cmp.mapping.close()";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      };
      sources = [
        {
          name = "nvim_lsp";
        }
        {
          name = "luasnip";
        }
        {
          name = "path";
        }
        {
          name = "buffer";
        }
        {
          name = "conventionalcommits";
        }
        {
          name = "dictionary";
        }
        {
          name = "copilot";
        }
        # {
        # name = "codeium";
        # }
      ];
    };
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
}
