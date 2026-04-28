{ pkgs, ... }:
# VSCode expects writable settings.json
# https://github.com/nix-community/home-manager/issues/1800
# We use a custom module for VSCode
{
  imports = [
    ./extensions.nix
    ./settings.nix
    ./keybindings.nix
  ];

  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium; # vscodium.fhs for complex extensions?
    profiles.default.enableUpdateCheck = false;

  };
}
