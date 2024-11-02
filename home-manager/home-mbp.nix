# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # inputs.self.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
    inputs.catppuccin.homeManagerModules.catppuccin

    # You can also split up your configuration and import pieces of it here:
    ./features/aws
    ./features/cli
    ./features/dev
    ./features/direnv
    # ./features/emacs
    ./features/git
    ./features/git/signing-mbp.nix
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
    # ./darwin/colima.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays your own flake exports (from overlays dir):
      inputs.self.overlays.additions
      inputs.self.overlays.stable-packages
      inputs.self.overlays.rosetta-packages
      inputs.self.overlays.modifications

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

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    DOTFILES = "$HOME/.dotfiles";
  };

  xdg.configFile."amethyst/amethyst.yml".source = ./darwin/amethyst.yml;
  xdg.configFile."borders/bordersrc" = {
    source = ./darwin/bordersrc;
    executable = true;
    onChange = "/bin/bash ${./darwin/bordersrc}";
  };
  xdg.configFile."sketchybar" = {
    source = ./darwin/sketchybar;
    recursive = true;
    onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
  };
  # xdg.dataFile."sketchybar_lua/sketchybar.so" = {
  #   source = "${pkgs.sbar-lua}/sketchybar.so";
  #   onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
  # };
  xdg.configFile."sketchybar/sketchybarrc" = {
    text = ''
      #!${pkgs.lua}/bin/lua

      -- Add the sketchybar module to the package cpath (the module could be
      -- installed into the default search path then this would not be needed)
      package.cpath = package.cpath .. ";${pkgs.sbar-lua}/lib/lua/${pkgs.lua.luaversion}/sketchybar.so"
      -- Search for local modules
      package.path = "./?.lua;./?/init.lua;" .. package.path

      -- Load the sketchybar-package and prepare the helper binaries
      require("helpers")
      require("init")
    '';
    executable = true;
    onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
  };

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
