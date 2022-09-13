{ config, lib, pkgs, ... }:
# VSCode expects writable settings.json
# https://github.com/nix-community/home-manager/issues/1800
with lib;
let
  cfg = config.modules.home.editors.vscode;
  vscodePname = config.programs.vscode.package.pname;

  configDir = {
    "vscode" = "Code";
    "vscode-insiders" = "Code - Insiders";
    "vscodium" = "VSCodium";
  }.${vscodePname};

  sysDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "${config.home.homeDirectory}/Library/Application Support"
    else
      "${config.xdg.configHome}";

  userFilePath = "${sysDir}/${configDir}/User/settings.json";

in
{
  options.modules.home.editors.vscode = {
    enable = mkEnableOption "VS Code";
    mutable = mkEnableOption "Mutable configuration";
  };

  config = mkIf cfg.enable {
    home = {
      activation = mkIf cfg.mutable {
        removeExistingVSCodeSettings = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
          rm -rf "${userFilePath}"
        '';

        overwriteVSCodeSymlink =
          let
            userSettings = config.programs.vscode.userSettings;
            jsonSettings = pkgs.writeText "tmp_vscode_settings" (builtins.toJSON userSettings);
          in
          lib.hm.dag.entryAfter [ "linkGeneration" ] ''
            rm -rf "${userFilePath}"
            cat ${jsonSettings} | ${pkgs.jq}/bin/jq --monochrome-output > "${userFilePath}"
          '';
      };
    };

    programs.vscode =
      let
        # Extension issues and other documentation:
        # https://nixos.wiki/wiki/VSCodium
        exts = (import ./extensions.nix).extensions;
      in
      {
        enable = true;
        package = pkgs.vscodium; # vscodium.fhs for complex extensions?
        userSettings = lib.importJSON ./settings.json;
        extensions = with pkgs.vscode-extensions; [
          ## Extensions present in nixpkgs
          ## Clashing with complete list appended below
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
          haskell.haskell
          jakebecker.elixir-ls
          james-yu.latex-workshop
          jnoortheen.nix-ide
          justusadam.language-haskell
          llvm-vs-code-extensions.vscode-clangd
          ms-azuretools.vscode-docker
          ms-python.python
          ms-python.vscode-pylance
          ms-vscode-remote.remote-ssh
          pkief.material-icon-theme
          pkief.material-product-icons
          usernamehw.errorlens
          valentjn.vscode-ltex
          zxh404.vscode-proto3
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace exts;
      };
  };
}

