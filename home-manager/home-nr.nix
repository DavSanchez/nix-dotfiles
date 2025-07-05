{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.catppuccin.homeModules.catppuccin
    inputs.mac-app-util.homeManagerModules.default

    ./features/ai
    ./features/aws
    ./features/cli
    ./features/dev/default-nr.nix
    ./features/direnv
    # ./features/emacs
    ./features/git
    ./features/git/signing-nr.nix
    ./features/neovim
    ./features/nu
    ./features/starship
    ./features/vscode
    ./features/zed
    ./features/zsh
    ./features/bash
    ./features/fish
    ./features/zellij
    ./features/terminals

    ./features/fonts.nix
    ./features/helix.nix
    ./features/tmux.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.stable-packages
      inputs.self.overlays.rosetta-packages
      inputs.self.overlays.modifications
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

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

  programs.home-manager.enable = true;
  programs.git.enable = true;

  xdg.enable = true;

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
