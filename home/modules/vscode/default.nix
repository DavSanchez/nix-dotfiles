{ pkgs, ... }:
# VSCode expects writable settings.json
# https://github.com/nix-community/home-manager/issues/1800
# We use a custom module for VSCode
{
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium; # vscodium.fhs for complex extensions?

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      userSettings = (import ./settings.nix) pkgs; # Pass pkgs to reference paths
      # Extra keybindings leveraging hyper key (to modify)
      keybindings = import ./keybindings.nix;
      # Extension issues and other documentation:
      # https://nixos.wiki/wiki/VSCodium
      extensions = (import ./extensions.nix) pkgs;
    };
  };
}
