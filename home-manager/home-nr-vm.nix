{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
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
    ./features/zsh
    ./features/bash
    ./features/fish
    ./features/zellij
    # ./features/terminals

    ./features/fonts.nix
    ./features/helix.nix
    ./features/tmux.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.rosetta-packages
      outputs.overlays.stable-packages
      outputs.overlays.modifications
      outputs.overlays.devenv
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "david";
    homeDirectory = "/home/david";
  };

  programs.zsh.cdpath = [
    "/home/david/NR-Repos"
  ];
  programs.zsh.shellAliases = {
    sshCAOS = "ssh -i ~/.ssh/caos-dev-arm.cer -o \"StrictHostKeyChecking no\"";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  xdg.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
