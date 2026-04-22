{ inputs,  ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.catppuccin.homeModules.catppuccin

    inputs.self.homeModules.hermes-agent

    ./modules/ai.nix
    ./modules/aws.nix
    ./modules/cli
    ./modules/dev
    ./modules/direnv.nix
    # ./modules/emacs
    ./modules/git
    ./modules/git/signing-solio.nix
    ./modules/neovim
    ./modules/nu.nix
    ./modules/starship.nix
    ./modules/vscode
    ./modules/zed.nix
    ./modules/zellij
    ./modules/zsh
    ./modules/bash.nix
    ./modules/fish.nix
    ./modules/terminals

    ./modules/app.nix
    ./modules/fonts.nix
    ./modules/helix.nix
    ./modules/tmux.nix
    ./modules/cava.nix

    # Darwin specifics
    ./modules/darwin/aerospace.nix
    ./modules/nixpkgs.nix
    ./modules/theme.nix
  ];

  home = {
    username = "david";
    homeDirectory = "/Users/david";
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      DOTFILES = "$HOME/.dotfiles";
      EDITOR = "hx";
    };
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
  xdg.enable = true;
}
