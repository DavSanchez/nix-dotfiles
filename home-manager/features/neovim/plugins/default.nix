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
  nvim-cmp = {
    enable = true;
    autoEnableSources = true;
    sources = [
      {name = "nvim_lsp";}
      {name = "path";}
      {name = "buffer";}
      # {name = "luasnip";}
      {name = "codeium";}
    ];

    mapping = {
      "<CR>" = "cmp.mapping.confirm({ select = true })";
      "<Tab>" = {
        action = ''
          function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            -- elseif luasnip.expandable() then
            --   luasnip.expand()
            -- elseif luasnip.expand_or_jumpable() then
            --   luasnip.expand_or_jump()
            elseif check_backspace() then
              fallback()
            else
              fallback()
            end
          end
        '';
        modes = ["i" "s"];
      };
    };
  };
  oil.enable = true;
  rustaceanvim.enable = true;
  telescope.enable = true;
  treesitter.enable = true;
  undotree.enable = true;
  which-key.enable = true;
}
