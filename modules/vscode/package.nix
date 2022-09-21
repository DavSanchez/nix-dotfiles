{
  config,
  lib,
  pkgs,
  ...
}:
# VSCode expects writable settings.json
# https://github.com/nix-community/home-manager/issues/1800
with lib; let
  cfg = config.modules.home.editors.vscode;
  vscodePname = config.programs.vscode.package.pname;

  configDir =
    {
      "vscode" = "Code";
      "vscode-insiders" = "Code - Insiders";
      "vscodium" = "VSCodium";
    }
    .${vscodePname};

  sysDir =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "${config.home.homeDirectory}/Library/Application Support"
    else "${config.xdg.configHome}";

  userFilePath = "${sysDir}/${configDir}/User/settings.json";
in {
  options.modules.home.editors.vscode = {
    enable = mkEnableOption "VS Code";
    mutable = mkEnableOption "Mutable configuration";
  };

  config = mkIf cfg.enable {
    home = {
      activation = mkIf cfg.mutable {
        removeExistingVSCodeSettings = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
          rm -rf "${userFilePath}"
        '';

        overwriteVSCodeSymlink = let
          userSettings = config.programs.vscode.userSettings;
          jsonSettings = pkgs.writeText "tmp_vscode_settings" (builtins.toJSON userSettings);
        in
          lib.hm.dag.entryAfter ["linkGeneration"] ''
            rm -rf "${userFilePath}"
            cat ${jsonSettings} | ${pkgs.jq}/bin/jq --monochrome-output > "${userFilePath}"
          '';
      };
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium; # vscodium.fhs for complex extensions?
      userSettings = lib.importJSON ./settings.json;
      # Extension issues and other documentation:
      # https://nixos.wiki/wiki/VSCodium
      extensions = with pkgs.vscode-extensions;
        [
          ## Extensions present in nixpkgs
          ## Clashing with complete list in ./extensions.nix, so case by case here
          hashicorp.terraform
          matklad.rust-analyzer
          redhat.vscode-yaml
          betterthantomorrow.calva
          bungcip.better-toml
          christian-kohler.path-intellisense
          davidanson.vscode-markdownlint
          dbaeumer.vscode-eslint
          dhall.dhall-lang
          dhall.vscode-dhall-lsp-server
          eamodio.gitlens
          esbenp.prettier-vscode
          github.github-vscode-theme
          golang.go
          gruntfuggly.todo-tree
          haskell.haskell
          jakebecker.elixir-ls
          james-yu.latex-workshop
          jnoortheen.nix-ide
          justusadam.language-haskell
          llvm-vs-code-extensions.vscode-clangd
          ms-azuretools.vscode-docker
          # ms-python.python # FIXME Failing to build
          ms-python.vscode-pylance
          ms-toolsai.jupyter
          ms-vscode-remote.remote-ssh
          pkief.material-icon-theme
          pkief.material-product-icons
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
            name = "nix-env-selector";
            publisher = "arrterian";
            version = "1.0.9";
            sha256 = "0kdfhkdkffr3cdxmj7llb9g3wqpm13ml75rpkwlg1y0pkxcnlk2f";
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
            version = "1.15.19";
            sha256 = "13v1lqqfvgkf5nm89b39hci65fnz4j89ngkg9p103l1p1fhncr41";
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
            name = "remote-wsl";
            publisher = "ms-vscode-remote";
            version = "0.66.3";
            sha256 = "0lslahxz5c6qxlv7xrq6da1x8ry297c4hgx0cb3iln6brj93j20a";
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
  };
}
