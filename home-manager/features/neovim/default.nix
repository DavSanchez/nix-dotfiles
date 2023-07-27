{pkgs, ...}: {
  imports = [
    ./nvchad.nix
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs;
      [
        # Bash
        nodePackages.bash-language-server
        shellcheck

        # Docker
        nodePackages.dockerfile-language-server-nodejs
        hadolint

        # elm
        # elmPackages.elm-language-server
        # elmPackages.elm
        # elmPackages.elm-test
        # elmPackages.elm-format

        # grammar
        vale

        # Git
        gitlint

        # Go
        gopls

        # Haskell (HLS already available in my system)
        # haskellPackages.haskell-language-server

        # HTML/CSS/JS
        nodePackages.vscode-langservers-extracted

        # JavaScript
        nodePackages.typescript-language-server

        # lua
        luaformatter
        sumneko-lua-language-server

        # Make
        # cmake-language-server

        # Markdown
        nodePackages.markdownlint-cli
        # This is a cli utility as we can't display all this in cli
        pandoc

        # Nix
        nixd
        deadnix
        statix
        # Purescript
        # nodePackages.purescript-language-server

        # python
        python3Packages.isort
        nodePackages.pyright
        black
        python3Packages.flake8
        mypy

        # Rust
        rust-analyzer
        rustfmt
        clippy
        # lldb # debugging setup

        # SQL
        sqls

        # terraform
        terraform-ls

        # TOML
        taplo-cli

        # Vimscript
        nodePackages.vim-language-server

        # YAML
        nodePackages.yaml-language-server
        yamllint

        # general purpose / multiple langs
        efm-langserver
        nodePackages.prettier
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [
        ltex-ls
      ]);
    plugins = with pkgs.vimPlugins; [
      # Appearance
      bufferline-nvim
      indent-blankline-nvim
      lualine-nvim
      # nvim-alpha # custom plugin
      nvim-colorizer-lua
      # nvim-headlines # custom plugin
      nvim-web-devicons

      # Appearance: Themes
      dracula-vim
      one-nvim
      tokyonight-nvim

      # DAP
      nvim-dap
      # nvim-dap-python # custom plugin
      nvim-dap-ui

      # File Tree
      nvim-tree-lua

      # Fuzzy Finder
      cheatsheet-nvim
      # nvim-better-digraphs # custom plugin
      telescope-fzf-native-nvim
      telescope-nvim

      # General Deps
      nui-nvim
      plenary-nvim
      popup-nvim

      # Git
      gitsigns-nvim
      vim-fugitive

      # Programming: LSP
      fidget-nvim
      lsp_signature-nvim
      lspkind-nvim
      null-ls-nvim
      nvim-lspconfig
      # nvim-lspsaga # custom plugin
      # nvim-sqls # custom plugin
      rust-tools-nvim

      # Progrmming: Treesitter
      (nvim-treesitter.withPlugins (plugins:
        with plugins; [
          tree-sitter-bash
          tree-sitter-c
          tree-sitter-clojure
          tree-sitter-cpp
          tree-sitter-css
          tree-sitter-dockerfile
          tree-sitter-elixir
          tree-sitter-elm
          tree-sitter-go
          tree-sitter-haskell
          tree-sitter-hcl
          tree-sitter-html
          tree-sitter-java
          tree-sitter-javascript
          tree-sitter-json
          tree-sitter-latex
          tree-sitter-lua
          tree-sitter-markdown
          tree-sitter-markdown-inline
          tree-sitter-nix
          tree-sitter-python
          tree-sitter-r
          tree-sitter-regex
          tree-sitter-ruby
          tree-sitter-rust
          tree-sitter-scss
          tree-sitter-sql
          tree-sitter-supercollider
          tree-sitter-toml
          tree-sitter-tsx
          tree-sitter-typescript
          tree-sitter-verilog
          tree-sitter-yaml
          tree-sitter-zig
        ]))
      # nvim-nu # custom plugin
      nvim-treesitter-refactor
      nvim-treesitter-textobjects
      which-key-nvim

      # Programming: Language support
      crates-nvim
      conjure
      vimtex
      # purescript-vim
      # nvim-yuck # custom plugin

      ## Programming: Autocompletion setup
      nvim-cmp
      cmp-buffer
      cmp-calc
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-path
      cmp-treesitter
      cmp-vsnip
      vim-vsnip
      vim-vsnip-integ

      ## Project management
      direnv-vim
      project-nvim

      # Text Helpers
      # nvim-regexplainer # custom plugin
      todo-comments-nvim
      venn-nvim
      vim-haskellConcealPlus
      vim-table-mode

      # Text objects
      nvim-autopairs
      nvim-comment
      nvim-surround

      vim-haskellConcealPlus
      vim-nix
      lualine-nvim
      nvim-web-devicons
      auto-pairs
      plenary-nvim
      telescope-nvim
      nerdtree
      neovim-ayu

      # GitHub Copilot
      copilot-vim
    ];
  };
}
