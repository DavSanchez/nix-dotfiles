pkgs:
(with pkgs.vscode-extensions; [
  ## Extensions present in nixpkgs
  ## Clashing with complete list in ./extensions.nix, so case by case here
  arrterian.nix-env-selector
  banacorn.agda-mode
  bbenoist.nix
  # betterthantomorrow.calva
  # catppuccin.catppuccin-vsc # Delegated to catppuccin flake
  catppuccin.catppuccin-vsc-icons
  christian-kohler.path-intellisense
  davidanson.vscode-markdownlint
  dbaeumer.vscode-eslint
  # dhall.dhall-lang
  # dhall.vscode-dhall-lsp-server
  editorconfig.editorconfig
  elixir-lsp.vscode-elixir-ls
  # github.copilot
  # github.copilot-chat
  github.vscode-github-actions
  github.vscode-pull-request-github
  golang.go
  gruntfuggly.todo-tree
  haskell.haskell
  # james-yu.latex-workshop
  jnoortheen.nix-ide
  justusadam.language-haskell
  llvm-vs-code-extensions.vscode-clangd
  # markis.code-coverage # FIXME
  mkhl.direnv
  ms-vscode-remote.remote-ssh
  ms-vscode-remote.remote-containers
  ms-vscode.hexeditor
  # ms-vscode.makefile-tools
  ms-vsliveshare.vsliveshare
  mvllow.rose-pine
  nefrob.vscode-just-syntax
  redhat.vscode-yaml
  rust-lang.rust-analyzer
  tamasfe.even-better-toml
  thenuprojectcontributors.vscode-nushell-lang
  timonwong.shellcheck
  usernamehw.errorlens
  vadimcn.vscode-lldb
  valentjn.vscode-ltex
  vscode-icons-team.vscode-icons
  vscodevim.vim
  zxh404.vscode-proto3
  ziglang.vscode-zig
])
++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  {
    name = "disableligatures";
    publisher = "CoenraadS";
    version = "0.0.10";
    sha256 = "090wg4lin4y06nhg45p9mjsqwfa21bdgafj57swh5z6fpv3pqxx2";
  }
  # {
  #   name = "vscode-keypromoter";
  #   publisher = "donebd";
  #   version = "1.0.3";
  #   sha256 = "sha256-yG5KPGoagKCvOCHXOA7ZARnKj+GyaD8D8HLmZKwI3kQ=";
  # }
  {
    name = "lambda-black";
    publisher = "janw4ld";
    version = "0.2.6";
    sha256 = "12rskwvz7vqr9s6875pv9k5rf8qknnljpwr9v8mrx0gh5cxds5yf";
  }
  {
    name = "nix-develop";
    publisher = "jamesottaway";
    version = "0.0.1";
    sha256 = "0dgkd3z0kxpaa2m01k0xqqsj9f01j4bac5sx8c3jhg19pg9zvl4m";
  }
  # {
  #   name = "remote-containers";
  #   publisher = "ms-vscode-remote";
  #   version = "0.285.0";
  #   sha256 = "0bg336vwiwbbzpjm4g1gra7qdd7gch7d13h6iv7lnvbl1h9plyjh";
  # }
  {
    name = "veriloghdl";
    publisher = "mshr-h";
    version = "1.5.12";
    sha256 = "sha256-D7Z3D2SBucBmtDbIEqst/2tGu1wtBFHMspU+wMyQJZE=";
  }
  # {
  #   name = "ide-purescript";
  #   publisher = "nwolverson";
  #   version = "0.26.1";
  #   sha256 = "sha256-ccTuoDSZKf1WsTRX2TxXeHy4eRuOXsAc7rvNZ2b56MU=";
  # }
  # {
  #   name = "language-purescript";
  #   publisher = "nwolverson";
  #   version = "0.2.8";
  #   sha256 = "1nhzvjwxld53mlaflf8idyjj18r1dzdys9ygy86095g7gc4b1qys";
  # }
  {
    name = "nix-extension-pack";
    publisher = "pinage404";
    version = "3.0.0";
    sha256 = "sha256-cWXd6AlyxBroZF+cXZzzWZbYPDuOqwCZIK67cEP5sNk=";
  }
  {
    name = "wavetrace";
    publisher = "wavetrace";
    version = "1.1.2";
    sha256 = "11k57vppx5i7i56kgp4b2r97g6fqmvm7x0mzf8zj5r42ipn070zg";
  }
]
