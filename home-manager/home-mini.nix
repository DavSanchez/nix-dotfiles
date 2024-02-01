# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./features/aws
    ./features/cli
    ./features/dev
    ./features/direnv
    # ./features/emacs
    ./features/git
    ./features/git/signing-mini.nix
    ./features/neovim
    ./features/nu
    ./features/starship
    ./features/vscode
    ./features/zellij
    ./features/zsh
    ./features/bash
    ./features/fish
    ./features/terminals

    ./features/app.nix
    ./features/fonts.nix
    ./features/helix.nix
    ./features/tmux.nix

    # Darwin specifics
    # ./features/darwin.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays your own flake exports (from overlays dir):
      outputs.overlays.additions
      outputs.overlays.stable-packages
      outputs.overlays.rosetta-packages
      outputs.overlays.modifications
      outputs.overlays.devenv

      # Or overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "david";
    homeDirectory = "/Users/david";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  xdg.enable = true;

  home.sessionPath = ["$HOME/.local/bin"];

  # Amethyst configuration
  home.file.".amethyst.yml" = {
    source = ./darwin/amethyst.yml;
  };
  # xdg.configFile."yabai/yabairc" = {
  #   source = ./darwin/yabairc;
  #   executable = true;
  #   onChange = ''
  #     /bin/launchctl stop org.nixos.yabai
  #     /bin/launchctl start org.nixos.yabai
  #     /bin/launchctl stop org.nixos.skhd
  #     /bin/launchctl start org.nixos.skhd
  #   '';
  # };
  # xdg.configFile."skhd/skhdrc" = {
  #   source = ./darwin/skhdrc;
  #   # executable = true;
  #   onChange = ''
  #     /bin/launchctl stop org.nixos.skhd
  #     /bin/launchctl start org.nixos.skhd
  #   '';
  # };
  # xdg.configFile."sketchybar" = {
  #   source = ./darwin/sketchybar;
  #   # recursive = true;
  #   onChange = ''
  #     /bin/launchctl stop org.nixos.sketchybar
  #     /bin/launchctl start org.nixos.sketchybar
  #   '';
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
