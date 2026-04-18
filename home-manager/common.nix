{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.catppuccin.homeModules.catppuccin

    ./features/ai
    ./features/aws
    ./features/cli
    ./features/dev
    ./features/direnv
    # ./features/emacs
    ./features/git
    ./features/neovim
    ./features/nu
    ./features/starship
    ./features/vscode
    ./features/zed
    ./features/zellij
    ./features/zsh
    ./features/bash
    ./features/fish
    ./features/terminals

    ./features/app.nix
    ./features/fonts.nix
    ./features/helix.nix
    ./features/tmux.nix
    ./features/cava.nix

    # Darwin specifics
    ./features/darwin/aerospace.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.stable-packages
      inputs.self.overlays.modifications
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "david";
    homeDirectory = "/Users/david";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  xdg.enable = true;

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    DOTFILES = "$HOME/.dotfiles";
    EDITOR = "hx";
  };

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
