{ lib
, pkgs
, ...
}:
# VSCode expects writable settings.json
# https://github.com/nix-community/home-manager/issues/1800
# We use a custom module for VSCode
{
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium; # vscodium.fhs for complex extensions?
    userSettings = lib.importJSON (
      if pkgs.stdenv.isDarwin
      then ./settings-darwin.json
      else ./settings.json
    );
    mutableExtensionsDir = true;
    # Extension issues and other documentation:
    # https://nixos.wiki/wiki/VSCodium
    extensions = with pkgs.vscode-extensions;
      [
        ## Extensions present in nixpkgs
        ## Clashing with complete list in ./extensions.nix, so case by case here
        arrterian.nix-env-selector
        betterthantomorrow.calva
        bungcip.better-toml
        catppuccin.catppuccin-vsc
        christian-kohler.path-intellisense
        davidanson.vscode-markdownlint
        dbaeumer.vscode-eslint
        dhall.dhall-lang
        dhall.vscode-dhall-lsp-server
        eamodio.gitlens
        elmtooling.elm-ls-vscode
        # esbenp.prettier-vscode
        github.copilot
        github.github-vscode-theme
        golang.go
        gruntfuggly.todo-tree
        hashicorp.terraform
        haskell.haskell
        jakebecker.elixir-ls
        james-yu.latex-workshop
        jdinhlife.gruvbox
        jnoortheen.nix-ide
        justusadam.language-haskell
        llvm-vs-code-extensions.vscode-clangd
        matklad.rust-analyzer
        mkhl.direnv
        ms-azuretools.vscode-docker
        ms-python.python
        ms-python.vscode-pylance
        # ms-pyright.pyright
        ms-toolsai.jupyter
        ms-toolsai.jupyter-renderers
        ms-vscode-remote.remote-ssh
        ms-vscode.cmake-tools
        ms-vscode.hexeditor
        ms-vscode.makefile-tools
        ms-vscode.theme-tomorrowkit
        pkief.material-icon-theme
        pkief.material-product-icons
        redhat.vscode-yaml
        tiehuis.zig
        timonwong.shellcheck
        usernamehw.errorlens
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
        {
          name = "vscode-bazel";
          publisher = "BazelBuild";
          version = "0.7.0";
          sha256 = "sha256-/a34MMsHy7zmGrVAtjMWKmulwS+lip3J1YugkACMmxc=";
        }
        {
          name = "disableligatures";
          publisher = "CoenraadS";
          version = "0.0.10";
          sha256 = "090wg4lin4y06nhg45p9mjsqwfa21bdgafj57swh5z6fpv3pqxx2";
        }
        {
          name = "copilot-labs";
          publisher = "GitHub";
          version = "0.7.632";
          sha256 = "sha256-1sMC0xPWseIRXXVsMrisN3A4br36S9pp9hYzsSjanKM=";
        }
        {
          name = "nix-develop";
          publisher = "jamesottaway";
          version = "0.0.1";
          sha256 = "0dgkd3z0kxpaa2m01k0xqqsj9f01j4bac5sx8c3jhg19pg9zvl4m";
        }
        {
          name = "vscode-kafka";
          publisher = "jeppeandersen";
          version = "0.15.0";
          sha256 = "1qf4a4d0wngyjdwdsbi8viska8i7gb56d1bc8cwa1ws07lz439gp";
        }
        {
          name = "vscode-postgresql";
          publisher = "ms-ossdata";
          version = "0.3.0";
          sha256 = "02sp5sv1sapynq4xx04b9z86jz2vmcsma1cpkbd05k2cw5g999lk";
        }
        {
          name = "cpptools-themes";
          publisher = "ms-vscode";
          version = "2.0.0";
          sha256 = "sha256-YWA5UsA+cgvI66uB9d9smwghmsqf3vZPFNpSCK+DJxc=";
        }
        {
          name = "remote-containers";
          publisher = "ms-vscode-remote";
          version = "0.267.0";
          sha256 = "sha256-glnDdEsvlmcux+ZO9uyhBZHCey6ge6+nQ1GCXSvqLoM=";
        }
        {
          name = "veriloghdl";
          publisher = "mshr-h";
          version = "1.5.12";
          sha256 = "sha256-D7Z3D2SBucBmtDbIEqst/2tGu1wtBFHMspU+wMyQJZE=";
        }
        {
          name = "ide-purescript";
          publisher = "nwolverson";
          version = "0.26.1";
          sha256 = "sha256-ccTuoDSZKf1WsTRX2TxXeHy4eRuOXsAc7rvNZ2b56MU=";
        }
        {
          name = "language-purescript";
          publisher = "nwolverson";
          version = "0.2.8";
          sha256 = "1nhzvjwxld53mlaflf8idyjj18r1dzdys9ygy86095g7gc4b1qys";
        }
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
      ];
  };
}
