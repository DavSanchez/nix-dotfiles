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
    inputs.nh_darwin.nixDarwinModules.prebuiltin

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    # ./common/yabai.nix
    # ./common/skhd.nix
    # ./common/sketchybar.nix
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
    package = pkgs.nixVersions.nix_2_23;
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
      automatic = false; # see programs.nh.clean
      interval = {
        Day = 7;
      };
    };

    linux-builder = {
      enable = true;
      ephemeral = true;
    };
  };

  # Alias for nh_darwin
  environment.shellAliases.nh = "nh_darwin";

  programs.nh = {
    enable = true;
    clean.enable = true;
    # Installation option once https://github.com/LnL7/nix-darwin/pull/942 is merged:
    # package = nh_darwin.packages.${pkgs.stdenv.hostPlatform.system}.default;
    os.flake = "/Users/david/.dotfiles";
    home.flake = "/Users/david/.dotfiles";
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
    nix-daemon.enable = true; # Auto upgrade nix package and the daemon service.
    tailscale = {
      enable = false; # Using App Store application for the moment
      overrideLocalDns = false;
    };

    sketchybar = {
      enable = true;
      extraPackages = [ pkgs.lua ];
    };
    jankyborders.enable = true;
  };
  networking.hostName = "Davids-MacBook-Pro";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh = {
      enable = true; # default shell on Catalina+
    };
    # fish.enable = true;
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

    taps = [
      "homebrew/cask-drivers" # for qFlipper
    ];
    casks = [
      "adobe-acrobat-reader"
      "amethyst"
      "brave-browser"
      "crossover"
      "discord"
      "disk-inventory-x"
      "firefox"
      "gqrx"
      "handbrake"
      "iina"
      "imhex"
      "insomnia"
      "jordanbaird-ice"
      "keymapp"
      "krita"
      "little-snitch"
      "logseq"
      "maccy"
      "openemu"
      "openra"
      "plex"
      "proton-drive"
      "proton-mail"
      "protonmail-bridge"
      "proton-pass"
      "protonvpn"
      "qflipper"
      "raycast"
      "remarkable"
      "secretive"
      "sonic-pi"
      "stats"
      "steam"
      "synthesia"
      "tor-browser"
      "transmission"
      "vlc"
      "whatsapp"
      "wireshark"
      "xld"
      "xquartz" # X11 applications on macOS
      "yacreader"
      "zed"
      "zerotier-one"
    ];
    brews = [ ];
    masApps = {
      "1Blocker" = 1365531024;
      "Amphetamine" = 937984704;
      "Draw Things" = 6444050820;
      "Hush" = 1544743900;
      "iMovie" = 408981434;
      "Keynote" = 409183694;
      "Logic Pro" = 634148309;
      "MainStage" = 634159523;
      "Microsoft Remote Desktop" = 1295203466;
      "Numbers" = 409203825;
      "one sec" = 1532875441;
      "Pages" = 409201541;
      "Proton Pass for Safari" = 6502835663;
      "Tailscale" = 1475387142;
      "Reeder" = 1529448980;
      "Shazam" = 897118787;
      "The Unarchiver" = 425424353;
      "Xcode" = 497799835;
    };
    # extraConfig = '' '';
    # whalebrews = [ ];
  };

  ## Other configs
  # Enable sudo authentication with Touch ID
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "left";
  # system.defaults.dock.showhidden = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  # system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.ShowStatusBar = true;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.defaults.magicmouse.MouseButtonMode = "TwoButton";

  # Make way for the sketchybar
  system.defaults.NSGlobalDomain._HIHideMenuBar = config.services.sketchybar.enable;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
