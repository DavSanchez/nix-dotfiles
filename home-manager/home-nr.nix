{
  inputs,
  lib,
  pkgs,
  ...
}:
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
    ./features/git/signing-nr.nix
    ./features/neovim
    ./features/nu.nix
    ./features/starship.nix
    ./features/vscode
    ./features/zed.nix
    ./features/zsh
    ./features/bash.nix
    ./features/fish.nix
    ./features/zellij
    ./features/terminals
    ./features/fonts.nix
    ./features/helix.nix
    ./features/tmux.nix
    ./features/nixpkgs.nix
    ./features/theme.nix

    # Darwin specifics
    ./features/darwin/aerospace.nix
  ];

  home = {
    username = "davidsanchez";
    homeDirectory = "/Users/davidsanchez";
    sessionVariables = {
      DOTFILES = "$HOME/.dotfiles";
      EDITOR = "hx";
    };
  };

  programs.zsh.cdpath = [ "/Users/davidsanchez/Developer/NR-Repos" ];
  programs.zsh.shellAliases = {
    sshCAOS = "ssh -i ~/.ssh/caos-dev-arm.cer -o \"StrictHostKeyChecking no\"";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.rd/bin"
  ];

  home.packages = with pkgs; [
    bruno
    bruno-cli

    obsidian
    obsidian-export

    yq-go

    trivy
    lazytrivy
  ];

  # Force loading fish from zsh since I haven't enabled it globally for this config
  programs.ghostty.settings.command = lib.mkForce "zsh -c \"exec fish\"";

  programs.home-manager.enable = true;

  xdg.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
