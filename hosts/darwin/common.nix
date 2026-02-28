{
  pkgs,
  inputs,
  config,
  ...
}:
{
  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.stable-packages
      inputs.self.overlays.modifications
    ];
    config = {
      allowUnfree = true;
    };
    hostPlatform = "aarch64-darwin";
  };

  nix = {
    settings = {
      trusted-users = [
        "root"
        "david"
      ];
      experimental-features = "nix-command flakes";
      extra-platforms = "x86_64-darwin aarch64-darwin";
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
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      config.boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
    };
  };

  environment.systemPackages = with pkgs; [ vim ];

  services = {
    tailscale = {
      enable = false; # Using standalone application for now
      overrideLocalDns = false;
    };
    sketchybar.enable = false;
    jankyborders = {
      enable = false; # Called on aerospace startup
      active_color = "0xffe1e3e4";
      inactive_color = "0xff494d64";
    };
  };

  programs = {
    zsh.enable = true;
    fish = {
      enable = true;
      useBabelfish = true;
    };
  };

  users.users.david = {
    name = "david";
    home = "/Users/david";
  };

  homebrew = {
    enable = true;
    global.brewfile = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    taps = [ ];
    brews = [ "mole" ];
    casks = [
      "adobe-acrobat-reader"
      "affinity"
      "anytype"
      # "background-music"
      "bartender"
      "brave-browser"
      "claude"
      "crossover"
      "gqrx"
      "handbrake-app"
      "keymapp"
      "krita"
      "little-snitch"
      "logseq"
      "openra"
      "orion"
      "proton-drive"
      "proton-mail"
      "proton-pass"
      "protonvpn"
      "qflipper"
      "secretive"
      "sonic-pi"
      "steam"
      "tailscale-app"
      "virtualbox"
      "vlc"
      "whatsapp"
      "wireshark-app"
      "xld"
      "xquartz"
      "yacreader"
      "zen"
    ];
    masApps = {
      "Amperfy" = 1530145038;
      "Amphetamine" = 937984704;
      "iMovie" = 408981434;
      "Keynote" = 409183694;
      "Logic Pro" = 634148309;
      "MainStage" = 634159523;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Proton Pass for Safari" = 6502835663;
      "Reeder" = 6475002485;
      "reMarkable" = 1276493162;
      "The Unarchiver" = 425424353;
      "uBlock Origin Lite" = 6745342698;
      "UTM" = 1538878817;
      "Windows App" = 1295203466;
    };
  };

  system.primaryUser = "david";
  system.defaults.dock.autohide = true;
  system.defaults.dock.expose-group-apps = true;
  system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
}
