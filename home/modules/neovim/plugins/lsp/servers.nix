{
  agda_ls = {
    enable = true;
    package = null;
  };
  ansiblels.enable = false;
  bashls.enable = true;
  clangd.enable = true;
  clojure_lsp.enable = true;
  dhall_lsp_server.enable = true;
  dockerls.enable = true;
  elixirls.enable = true;
  eslint.enable = true;
  gopls.enable = true;
  helm_ls.enable = true;
  hls = {
    enable = true;
    installGhc = false;
  };
  html.enable = true;
  idris2_lsp.enable = false;
  jsonls.enable = true;
  marksman.enable = true;
  nickel_ls.enable = true;
  nixd.enable = true;
  nushell.enable = true;
  pylsp.enable = true;
  pyright.enable = true;
  rust_analyzer = {
    enable = false; # Using rustaceanvim
    installCargo = false;
    installRustc = false;
  };
  taplo.enable = true;
  terraformls.enable = true;
  ts_ls.enable = true;
  yamlls.enable = true;
  zls.enable = true;
}
