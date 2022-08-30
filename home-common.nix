{ ... }:

{
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
    ./modules/fonts.nix
    ./modules/tmux.nix
    ./modules/wezterm.nix
  ];
}
