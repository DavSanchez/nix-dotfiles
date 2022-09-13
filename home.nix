{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;
  home.stateVersion = "22.05";
  # NOTE: Here we are injecting colorscheme so that it is passed down all the imports
  _module.args = {
    colorscheme = import ./colorschemes/tokyonight.nix;
  };

  # home.homeDirectory = "/Users/david";
  # home.username = "david";
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  imports = [
    ./modules/aws
    ./modules/dev
    ./modules/direnv
    # ./modules/emacs # Doom emacs (does not really work)
    ./modules/git
    ./modules/nu
    ./modules/neovim
    ./modules/starship
    ./modules/vscode # Extensions ?? System-level for helper?
    ./modules/zsh

    ./modules/app.nix
    ./modules/cli.nix
    ./modules/fonts.nix
    ./modules/zellij.nix
    ./modules/tmux.nix
    ./modules/wezterm.nix
  ];
}
