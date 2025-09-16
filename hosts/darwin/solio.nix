# This is your system's configuration file.
# Use this to configure your system environment (it replaces ~/.nixpkgs/darwin-configuration.nix)
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # You can import other nix-darwin modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/darwin):
    # inputs.self.darwinModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    inputs.mac-app-util.darwinModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    # ./common/aerospace.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays your own flake exports (from overlays dir):
      inputs.self.overlays.additions
      inputs.self.overlays.stable-packages
      inputs.self.overlays.modifications

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
    };
  };

  nix = {
    settings = {
      trusted-users = [
        "root"
        "david"
      ]; # For groups prepend @: "@admin"
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      extra-platforms = lib.optionalString (
        pkgs.system == "aarch64-darwin"
      ) "x86_64-darwin aarch64-darwin";

      # sandbox = true;
    };

    gc = {
      automatic = false; # See programs.nh.clean
      interval = {
        Day = 7;
      };
    };

    linux-builder = {
      enable = true;
      ephemeral = true;
    };
  };

  environment = {
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    systemPackages = with pkgs; [ vim ];
    # shells = with pkgs; [
    #   zsh
    #   bashInteractive
    # ];
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  services = {
    tailscale = {
      enable = false; # Using App Store application for the moment
      overrideLocalDns = false;
    };
    sketchybar.enable = false;
    jankyborders = {
      enable = false;
      active_color = "0xffe1e3e4";
      inactive_color = "0xff494d64";
    };
  };

  networking.hostName = "solio";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh = {
      enable = true; # default shell on Catalina+
      enableFzfCompletion = true;
      enableFzfGit = true;
    };
    fish = {
      enable = true;
      useBabelfish = true;
    };
    bash = {
      enable = true;
      completion.enable = true;
    };
  };

  users.users = {
    david = {
      name = "david";
      home = "/Users/david";
    };
  };

  homebrew = {
    enable = true;
    global.brewfile = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true; # This defaults to false so calls are idempotent.
    onActivation.cleanup = "zap";

    taps = [ ];
    casks = [
      "adobe-acrobat-reader"
      "anytype"
      "background-music"
      "brave-browser"
      "crossover"
      "discord"
      "disk-inventory-x"
      "gqrx"
      "handbrake-app"
      "iina"
      "imhex"
      "keymapp"
      "krita"
      "libreoffice"
      "little-snitch"
      "logseq"
      "openemu"
      "openra"
      "orion"
      "proton-drive"
      "proton-mail"
      "proton-mail-bridge"
      "proton-pass"
      "protonvpn"
      "qflipper"
      "secretive"
      "sonic-pi"
      "stats"
      "steam"
      "transmission"
      "virtualbox" # VMs
      "vlc"
      "whatsapp"
      "wireshark-app"
      "xld"
      "xquartz" # X11 applications on macOS
      "yacreader"
      "zen-browser"
      "zerotier-one"
    ];
    brews = [ ];
    masApps = {
      "Amphetamine" = 937984704;
      "Ghostery Privacy Ad Blocker" = 6504861501;
      "iMovie" = 408981434;
      "Keynote" = 409183694;
      "Logic Pro" = 634148309;
      "MainStage" = 634159523;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Proton Pass for Safari" = 6502835663;
      "Tailscale" = 1475387142;
      "Reeder" = 6475002485;
      "reMarkable" = 1276493162;
      "The Unarchiver" = 425424353;
      "UTM" = 1538878817; # VMs (qemu)
      "Windows App" = 1295203466;
      "Xcode" = 497799835;
    };
    # extraConfig = '' '';
    # whalebrews = [ ];
  };

  ## Other configs
  # Enable sudo authentication with Touch ID
  security.pam.services.sudo_local.watchIdAuth = true;

  system.primaryUser = "david";
  system.defaults.dock.autohide = true;
  system.defaults.dock.expose-group-apps = false;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "bottom";
  # system.defaults.dock.showhidden = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  # system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.ShowStatusBar = true;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.defaults.magicmouse.MouseButtonMode = "TwoButton";

  system.defaults.NSGlobalDomain._HIHideMenuBar = config.services.sketchybar.enable;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
