{
  pkgs,
  lib,
  ...
}: {
  # Enable sudo authentication with Touch ID
  security.pam.enableSudoTouchIdAuth = true;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions =
    ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    ''
    + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

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
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh.enable = true; # default shell on catalina
    nix-index.enable = true;
    # fish.enable = true;
  };

  fonts.fontDir.enable = true;

  users = {
    users.david = {
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
      "brave-browser"
      "dash"
      "diffusionbee" # Let's have some fun!
      "discord"
      "disk-inventory-x"
      "firefox-developer-edition"
      "gqrx"
      "handbrake"
      "imhex"
      "inso"
      "insomnia"
      "krita"
      "little-snitch"
      "logseq"
      "openemu"
      "openra"
      # "orion" # Alternative WebKit browser
      "protonmail-bridge"
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
      "warp"
      "wireshark"
      "xld"
      "yacreader"
      "zotero"
    ];
    brews = [
      "conan"
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
      "The Unarchiver" = 425424353;
      "UTM" = 1538878817;
      "WhatsApp" = 1147396723;
      "Xcode" = 497799835;
    };
    # extraConfig = '' '';
    # whalebrews = [ ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
