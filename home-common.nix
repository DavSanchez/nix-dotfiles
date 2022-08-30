{ lib, nur, ... }:
{
  # NOTE: Here we are injecting colorscheme so that it is passed down all the imports
  _module.args = {
    colorscheme = import ./colorschemes/tokyonight.nix;
  };

  nixpkgs.overlays = [
    nur.overlay
  ];

  # Allow all unfree packages
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  programs.home-manager.enable = true;
  home.stateVersion = "22.05";

  imports = [
    ./modules/aws
    ./modules/dev
    ./modules/direnv
    ./modules/emacs
    ./modules/git
    # ./modules/nu # Per-system
    ./modules/nvim
    ./modules/starship
    ./modules/vscode
    ./modules/zsh

    ./modules/app.nix
    ./modules/cli.nix
    ./modules/font.nix
    ./modules/tmux.nix
    ./modules/wezterm.nix
  ];
}
