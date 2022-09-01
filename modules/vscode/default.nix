{ lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # pinage404.nix-extension-pack
      rust-lang.rust-analyzer
      bungcip.better-toml
      golang.go
      haskell.haskell
      # vscode-icons-team.vscode-icons
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-azuretools.vscode-docker
      # jeppeandersen.vscode-kafka
      usernamehw.errorlens
      eamodio.gitlens
      # liviuschera.noctis
      # aaron-bond.better-comments
    ];
    #haskell.enable = true;
    userSettings = lib.importJSON ./settings.json;
  };
}
