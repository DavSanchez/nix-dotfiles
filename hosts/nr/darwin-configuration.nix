# This is your system's configuration file.
# Use this to configure your system environment (it replaces ~/.nixpkgs/darwin-configuration.nix)
{
  pkgs,
  config,
  lib,
  inputs,
  outputs,
  ...
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

    inputs.nix-relic.darwinModules.newrelic-infra
    inputs.nix-relic.darwinModules.nr-otel-collector
  ];

  services.newrelic-infra = {
    enable = true;
    configFile = ../../secrets/newrelic-infra-config.yml;
  };

  services.nr-otel-collector = {
    enable = true;
    configFile = ../../secrets/nr-otel-collector-config.yml;
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays your own flake exports (from overlays dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # Or overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      inputs.nix-relic.overlays.additions

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
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    package = pkgs.nixUnstable;

    settings = {
      trusted-users = ["root" "davidsanchez"]; # For groups prepend @: "@admin"

      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = false;
    };
    extraOptions = lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    gc = {
      automatic = true;
      interval = {Day = 7;};
    };

    linux-builder = {
      enable = true;
    };
  };

  environment = {
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    systemPackages = with pkgs; [
      vim
    ];
    # shells = with pkgs; [
    #   zsh
    #   bashInteractive
    # ];
    systemPath = [
      "${config.homebrew.brewPrefix}/sbin"
    ];
    variables = {
      FPATH = "${(config.homebrew.brewPrefix)}/share/zsh/site-functions:$FPATH";
    };
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  networking.hostName = "V9X576T260";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh = {
      enable = true; # default shell on Catalina+
      enableFzfCompletion = true;
      enableFzfGit = true;
    }; # fish.enable = true;
    bash = {
      enable = true;
      enableCompletion = true;
    };
  };

  users.users = {
    davidsanchez = {
      name = "davidsanchez";
      home = "/Users/davidsanchez";
    };
  };

  homebrew = {
    enable = true;
    global.brewfile = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true; # This defaults to false so calls are idempotent.
    onActivation.cleanup = "zap";

    taps = [];
    casks = [
      "1password"
      "1password-cli"
      "amethyst"
      "anytype"  # Alternative to Notion, testing
      "bartender"
      "brave-browser"
      "disk-inventory-x"
      "docker"
      "finch"
      "firefox"
      "imhex"
      "insomnia"
      "logseq"
      "maccy"
      "openvpn-connect"
      "parallels"
      "raycast"
      "stats"
      "utm" # When tart is not enough
      "warp"
      "wireshark"
    ];
    brews = [
      "ghcup"
      "tart" # VMs on Apple Silicon
    ];
    masApps = {
      "1Blocker" = 1365531024;
      "1Password for Safari" = 1569813296;
      "Amphetamine" = 937984704;
      "Hush" = 1544743900;
      "Microsoft Remote Desktop" = 1295203466;
      "The Unarchiver" = 425424353;
    };
    # extraConfig = '' '';
    # whalebrews = [ ];
  };

  ## Other configs
  # Enable sudo authentication with Touch ID
  # security.pam.enableSudoTouchIdAuth = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "left";
  system.defaults.finder.AppleShowAllExtensions = true;
  # system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.ShowStatusBar = true;
  # system.keyboard.enableKeyMapping = true;
  # system.keyboard.remapCapsLockToControl = true;
  system.defaults.magicmouse.MouseButtonMode = "TwoButton";

  fonts.fontDir.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
