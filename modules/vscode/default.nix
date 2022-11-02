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
    package = pkgs.vscodium; # vscodium.fhs for complex extensions?
    userSettings = lib.importJSON ./settings.json;
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
        christian-kohler.path-intellisense
        davidanson.vscode-markdownlint
        dbaeumer.vscode-eslint
        dhall.dhall-lang
        dhall.vscode-dhall-lsp-server
        eamodio.gitlens
        # esbenp.prettier-vscode
        github.github-vscode-theme
        golang.go
        gruntfuggly.todo-tree
        hashicorp.terraform
        haskell.haskell
        jakebecker.elixir-ls
        james-yu.latex-workshop
        jnoortheen.nix-ide
        justusadam.language-haskell
        llvm-vs-code-extensions.vscode-clangd
        matklad.rust-analyzer
        ms-azuretools.vscode-docker
        # ms-python.python # FIXME Failing to build, added below
        ms-python.vscode-pylance
        ms-toolsai.jupyter
        ms-toolsai.jupyter-renderers
        ms-vscode-remote.remote-ssh
        pkief.material-icon-theme
        pkief.material-product-icons
        redhat.vscode-yaml
        tiehuis.zig
        timonwong.shellcheck
        usernamehw.errorlens
        valentjn.vscode-ltex
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
          version = "0.5.0";
          sha256 = "0gjf42xjhzwbncd6c8p7c60m44bkhk2kcpa3qjg2vr619p0i5514";
        }
        {
          name = "disableligatures";
          publisher = "CoenraadS";
          version = "0.0.10";
          sha256 = "090wg4lin4y06nhg45p9mjsqwfa21bdgafj57swh5z6fpv3pqxx2";
        }
        {
          name = "doxdocgen";
          publisher = "cschlosser";
          version = "1.4.0";
          sha256 = "1d95znf2vsdzv9jqiigh9zm62dp4m9jz3qcfaxn0n0pvalbiyw92";
        }
        {
          name = "nix-develop";
          publisher = "jamesottaway";
          version = "0.0.1";
          sha256 = "0dgkd3z0kxpaa2m01k0xqqsj9f01j4bac5sx8c3jhg19pg9zvl4m";
        }
        {
          name = "better-cpp-syntax";
          publisher = "jeff-hykin";
          version = "1.16.3";
          sha256 = "1fdchrm3i7qlhqnyi2icgcmi4b0kr27bp0mgys7iyswfqh3nfji7";
        }
        {
          name = "vscode-kafka";
          publisher = "jeppeandersen";
          version = "0.15.0";
          sha256 = "1qf4a4d0wngyjdwdsbi8viska8i7gb56d1bc8cwa1ws07lz439gp";
        }
        {
          name = "direnv";
          publisher = "mkhl";
          version = "0.6.1";
          sha256 = "1d60hqww1innch277yd3va2snpsp19c7w4v0rxz2jvzvgykfmx77";
        }
        {
          name = "python";
          publisher = "ms-python";
          version = "2022.15.12631011";
          sha256 = "04zhvgkpbjfjbdxflkrsi874ldlijs295phvp8f1zprxg8qd5f8a";
        }
        {
          name = "vscode-postgresql";
          publisher = "ms-ossdata";
          version = "0.3.0";
          sha256 = "02sp5sv1sapynq4xx04b9z86jz2vmcsma1cpkbd05k2cw5g999lk";
        }
        {
          name = "remote-containers";
          publisher = "ms-vscode-remote";
          version = "0.252.0";
          sha256 = "1yrjfxccvg7j64l47ixzc7r1234r7nqk0j3500a8ihfi6qi7cxx5";
        }
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.80.0";
          sha256 = "0zgrd2909xpr3416cji0ha3yl6gl2ry2f38bvx4lsjfmgik0ic6s";
        }
        {
          name = "hexeditor";
          publisher = "ms-vscode";
          version = "1.9.8";
          sha256 = "063n4plhbjm6l5gip6j158n6hgydiccq1f8rc1pgsbfjn3d4612y";
        }
        {
          name = "veriloghdl";
          publisher = "mshr-h";
          version = "1.5.4";
          sha256 = "1i8qcfx5v4d30gkyy00a4d8l6ss828va6lp69h9i1ynrgqzl85av";
        }
        {
          name = "ide-purescript";
          publisher = "nwolverson";
          version = "0.25.12";
          sha256 = "1f9064w18wwp3iy8ciajad8vlshnzyhnqy8h516k0j5bflz781mn";
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
          version = "2.0.0";
          sha256 = "176fl2p5ybifi3w4pcvs9z45mbzh60li84kwysqpn4zz1dpfdgbp";
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
