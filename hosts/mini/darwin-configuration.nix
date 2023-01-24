# This is your system's configuration file.
# Use this to configure your system environment (it replaces ~/.nixpkgs/darwin-configuration.nix)

{ pkgs
, config
, lib
, inputs
, ...
}: {
  # You can import other nix-darwin modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/darwin):
    # outputs.darwinModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays your own flake exports (from overlays dir):
      # outputs.overlays.modifications
      # outputs.overlays.additions

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
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    package = pkgs.nixUnstable;

    settings = {
      trusted-users = [ "root" "david" ]; # For groups prepend @: "@admin"

      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
    extraOptions =
      ''
        auto-optimise-store = true
        experimental-features = nix-command flakes
      ''
      + lib.optionalString (pkgs.system == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
    gc = {
      automatic = true;
      interval = { Day = 7; };
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh.enable = true; # default shell on Catalina+
    nix-index.enable = true;
    # fish.enable = true;
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
    onActivation.upgrade = true; # This defaults to false so calls are idempotent.
    onActivation.cleanup = "zap";

    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-versions"
    ];
    casks = [
      "adobe-acrobat-reader"
      "amethyst"
      "authy"
      "brave-browser"
      # "dash" # Haven't used it
      "diffusionbee" # Let's have some fun!
      "discord"
      "disk-inventory-x"
      "finch"
      "firefox"
      "ghidra"
      "gqrx"
      "handbrake"
      "imhex"
      "inso"
      "insomnia"
      "keybase"
      "krita"
      "libreoffice"
      "little-snitch"
      "logseq"
      "openemu"
      "openra"
      # "orion" # Alternative WebKit browser
      "plex-media-server"
      "protonmail-bridge"
      "protonvpn"
      "qflipper"
      # "raycast" # I do not find it that useful at the moment
      "remarkable"
      "secretive"
      # "shortcat" # Manipulate macOS masterfully, minus the mouse
      "sonic-pi"
      "stats"
      "steam"
      "synthesia"
      "tor-browser"
      "transmission"
      "vlc"
      "warp"
      "wireshark"
      "xld"
      "xquartz" # X11 applications on macOS
      "yacreader"
      "zotero"
    ];
    brews = [
      "bash"
      "conan"
      "ghcup"  # While Haskell for aarch64-darwin stabilizes in unstable
      "whalebrew"
      "pam-reattach" # https://github.com/fabianishere/pam_reattach
      # "terraform-rover"
    ];
    masApps = {
      "AdGuard for Safari" = 1440147259;
      "Amphetamine" = 937984704;
      "GarageBand" = 682658836;
      "Gemini 2" = 1090488118;
      "iMovie" = 408981434;
      "Keynote" = 409183694;
      "Logic Pro" = 634148309;
      "MainStage" = 634159523;
      "Microsoft Remote Desktop" = 1295203466;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Reeder" = 1529448980;
      "Spring for Twitter" = 1508706541;
      "The Unarchiver" = 425424353;
      "UTM" = 1538878817;
      "WhatsApp" = 1147396723;
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
  system.defaults.dock.orientation = "bottom";
  # system.defaults.dock.showhidden = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  # system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.ShowStatusBar = true;
  # system.keyboard.enableKeyMapping = true;
  # system.keyboard.remapCapsLockToControl = true;
  system.defaults.magicmouse.MouseButtonMode = "TwoButton";

  # fonts.fontDir.enable = true; # Ventura makes this segfault ?

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
