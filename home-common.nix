{ lib, ... }:
{
  # NOTE: Here we are injecting colorscheme so that it is passed down all the imports
  _module.args = {
    colorscheme = import ./colorschemes/tokyonight.nix;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];

  nixpkgs.overlays = [
    nur.overlay
    # taffybar.overlay
    # vim-plugins.overlay
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "22.05";

  imports = [
    ./modules/aws
    ./modules/dev
    ./modules/direnv
    ./modules/git
    ./modules/nu
    ./modules/nvim
    ./modules/starship
    # ./modules/system
    ./modules/zsh

    ./modules/app.nix
    ./modules/cli.nix
    ./modules/font.nix
    ./modules/tmux.nix
    ./modules/wezterm.nix
  ];
}
