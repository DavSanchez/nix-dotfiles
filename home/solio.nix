{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin

    inputs.sops-nix.homeManagerModules.sops

    ./modules/ai.nix
    ./modules/aws.nix
    ./modules/cli
    ./modules/dev
    ./modules/direnv.nix
    # ./modules/emacs
    ./modules/git
    ./modules/git/signing-solio.nix
    # ./modules/neovim
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
    ./modules/mail.nix

    # Darwin specifics
    ./modules/darwin/omniwm.nix
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

  programs.omniwm.enable = true;

  services.jankyborders = {
    enable = true;
    settings = {
      active_color = "0xffe1e3e4";
      inactive_color = "0xff494d64";
      width = 5.0;
    };
  };

  programs.home-manager.enable = true;
  xdg.enable = true;
}
