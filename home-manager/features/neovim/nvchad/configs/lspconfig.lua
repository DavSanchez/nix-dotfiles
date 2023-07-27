local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = {
  "html",
  "cssls",
  "tsserver",
  "clangd",
  -- "hls", -- activated below
  "bashls",
  "nixd",
  "rust_analyzer",
  "golangci_lint_ls",
  "gopls",
  "yamlls",
  "taplo",
  "idris2_lsp",
  -- "clojure_lsp",
  -- "elixirls",
  -- "gleam",
  -- "unison"
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- 
-- lspconfig.pyright.setup { blabla}
lspconfig.hls.setup{
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
  on_attach = on_attach,
  capabilities = capabilities,
}


