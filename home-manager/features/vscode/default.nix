{pkgs, ...}:
# VSCode expects writable settings.json
# https://github.com/nix-community/home-manager/issues/1800
# We use a custom module for VSCode
{
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium; # vscodium.fhs for complex extensions?
    userSettings = import ./settings.nix {inherit pkgs;}; # Pass pkgs to reference paths

    enableExtensionUpdateCheck = true;
    enableUpdateCheck = true;
    mutableExtensionsDir = true;

    # Extension issues and other documentation:
    # https://nixos.wiki/wiki/VSCodium
    extensions = with pkgs.vscode-extensions;
      [
        ## Extensions present in nixpkgs
        ## Clashing with complete list in ./extensions.nix, so case by case here
        arrterian.nix-env-selector
        bbenoist.nix
        betterthantomorrow.calva
        # catppuccin.catppuccin-vsc
        christian-kohler.path-intellisense
        davidanson.vscode-markdownlint
        dbaeumer.vscode-eslint
        # dhall.dhall-lang
        # dhall.vscode-dhall-lsp-server
        eamodio.gitlens
        # esbenp.prettier-vscode
        github.copilot
        github.copilot-chat
        # github.github-vscode-theme
        github.vscode-github-actions
        github.vscode-pull-request-github
        golang.go
        gruntfuggly.todo-tree
        hashicorp.terraform
        haskell.haskell
        jakebecker.elixir-ls
        james-yu.latex-workshop
        # jdinhlife.gruvbox
        jnoortheen.nix-ide
        justusadam.language-haskell
        llvm-vs-code-extensions.vscode-clangd
        matklad.rust-analyzer
        mkhl.direnv
        # ms-azuretools.vscode-docker
        # ms-kubernetes-tools.vscode-kubernetes-tools
        # ms-python.python
        # ms-python.vscode-pylance
        # ms-pyright.pyright
        # ms-toolsai.jupyter
        # ms-toolsai.jupyter-renderers
        ms-vscode-remote.remote-ssh
        # ms-vscode.cmake-tools
        ms-vscode.hexeditor
        # ms-vscode.makefile-tools
        # ms-vscode.theme-tomorrowkit
        pkief.material-icon-theme
        pkief.material-product-icons
        redhat.vscode-yaml
        tamasfe.even-better-toml
        timonwong.shellcheck
        usernamehw.errorlens
        # vadimcn.vscode-lldb
        valentjn.vscode-ltex
        vscodevim.vim
        zxh404.vscode-proto3
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "better-comments";
          publisher = "aaron-bond";
          version = "3.0.2";
          sha256 = "15w1ixvp6vn9ng6mmcmv9ch0ngx8m85i1yabxdfn6zx3ypq802c5";
        }
        # {
        #   name = "codestream";
        #   publisher = "CodeStream";
        #   version = "14.15.0";
        #   sha256 = "sha256-YCB2Emz9QWtXAJf5z2mnXOVtd6tUgSY/xX386HF72d0=";
        # }
        {
          name = "disableligatures";
          publisher = "CoenraadS";
          version = "0.0.10";
          sha256 = "090wg4lin4y06nhg45p9mjsqwfa21bdgafj57swh5z6fpv3pqxx2";
        }
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
        #   name = "vscode-kafka";
        #   publisher = "jeppeandersen";
        #   version = "0.15.0";
        #   sha256 = "1qf4a4d0wngyjdwdsbi8viska8i7gb56d1bc8cwa1ws07lz439gp";
        # }
        # {
        #   name = "vscode-postgresql";
        #   publisher = "ms-ossdata";
        #   version = "0.3.0";
        #   sha256 = "02sp5sv1sapynq4xx04b9z86jz2vmcsma1cpkbd05k2cw5g999lk";
        # }
        # {
        #   name = "cpptools-themes";
        #   publisher = "ms-vscode";
        #   version = "2.0.0";
        #   sha256 = "sha256-YWA5UsA+cgvI66uB9d9smwghmsqf3vZPFNpSCK+DJxc=";
        # }
        {
          name = "remote-containers";
          publisher = "ms-vscode-remote";
          version = "0.285.0";
          sha256 = "0bg336vwiwbbzpjm4g1gra7qdd7gch7d13h6iv7lnvbl1h9plyjh";
        }
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
          name = "vscode-icons";
          publisher = "vscode-icons-team";
          version = "12.2.0";
          sha256 = "sha256-PxM+20mkj7DpcdFuExUFN5wldfs7Qmas3CnZpEFeRYs=";
        }
        {
          name = "wavetrace";
          publisher = "wavetrace";
          version = "1.1.2";
          sha256 = "11k57vppx5i7i56kgp4b2r97g6fqmvm7x0mzf8zj5r42ipn070zg";
        }
        {
          name = "vscode-zig";
          publisher = "ziglang";
          version = "0.3.1";
          sha256 = "sha256-c38c0XbKa6BUWEIJikbHT9otqe9GTnOr9l1D58OUYp4=";
        }
      ];
  };
}
