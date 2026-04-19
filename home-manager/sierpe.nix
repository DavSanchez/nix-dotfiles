{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.catppuccin.homeModules.catppuccin

    ./features/ai.nix
    ./features/aws.nix
    ./features/cli
    ./features/dev
    ./features/direnv.nix
    # ./features/emacs
    ./features/git
    ./features/git/signing-sierpe.nix
    ./features/neovim
    ./features/nu.nix
    ./features/starship.nix
    ./features/vscode
    ./features/zed.nix
    ./features/zellij
    ./features/zsh
    ./features/bash.nix
    ./features/fish.nix
    ./features/terminals
    ./features/app.nix
    ./features/fonts.nix
    ./features/helix.nix
    ./features/tmux.nix
    ./features/cava.nix
    # Darwin specifics
    ./features/darwin/aerospace.nix
    ./features/nixpkgs.nix
    ./features/theme.nix
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
