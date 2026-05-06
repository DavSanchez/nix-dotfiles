{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.catppuccin.homeModules.catppuccin

    ./modules/ai.nix
    ./modules/aws.nix
    ./modules/cli
    ./modules/dev
    ./modules/direnv.nix
    # ./modules/emacs
    ./modules/git
    ./modules/git/signing-nr.nix
    ./modules/neovim
    ./modules/nu.nix
    ./modules/starship.nix
    ./modules/vscode
    ./modules/zed.nix
    ./modules/zsh
    ./modules/bash.nix
    ./modules/fish.nix
    ./modules/zellij
    ./modules/terminals
    ./modules/fonts.nix
    ./modules/helix.nix
    ./modules/tmux.nix
    ./modules/nixpkgs.nix
    ./modules/theme.nix

    # Darwin specifics
    ./modules/darwin/aerospace.nix
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

    fluxcd
  ];

  programs.home-manager.enable = true;

  xdg.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
