# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, ... }:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # inputs.self.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.nixvim.homeModules.nixvim
    inputs.catppuccin.homeModules.catppuccin

    # You can also split up your configuration and import pieces of it here:
    ./features/ai
    ./features/aws
    ./features/cli
    ./features/dev
    ./features/direnv
    # ./features/emacs # Using nvim + nvchad
    ./features/git
    ./features/neovim
    ./features/nu
    ./features/starship
    # ./features/zellij # Not using it (for now). Using tmux.
    ./features/zsh
    ./features/bash
    ./features/fish

    ./features/fonts.nix
    ./features/helix.nix
    ./features/tmux.nix
  ];

  home = {
    username = "david";
    homeDirectory = "/home/david";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
