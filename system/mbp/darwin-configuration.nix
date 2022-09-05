{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.vim
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";
    global.brewfile = true;
    global.noLock = true;

    taps = [
      "homebrew/cask"
      "homebrew/cask-versions"
      "railwaycat/emacsmacport"
    ];
    casks = [
      "adobe-acrobat-reader"
      "amethyst"
      "brave-browser"
      "dash"
      "discord"
      "disk-inventory-x"
      "firefox-developer-edition"
      "gqrx"
      "handbrake"
      "imhex"
      "inso"
      "insomnia"
      "little-snitch"
      "logseq"
      "mactex-no-gui"
      "openra"
      "protonmail-bridge"
      "protonvpn"
      "sonic-pi"
      "steam"
      "synthesia"
      "tor-browser"
      "transmission"
      "visual-studio-code"
      "vlc"
      "vmware-fusion-tech-preview"
      "warp"
      "wireshark"
      "xld"
      "yacreader"
      "zotero"
    ];
    brews = [
      "conan"
      "terraform-rover"
    ];
    masApps = {
      "AdGuard for Safari" = 1440147259;
      "Amphetamine" = 937984704;
      "GarageBand" = 682658836;
      "Gemini 2" = 1090488118;
      "iMovie" = 408981434;
      "iStat Menus" = 1319778037;
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
    extraConfig = ''
      brew "railwaycat/emacsmacport/emacs-mac", args: ["with-emacs-big-sur-icon", "with-starter", "with-native-comp"]
    '';
    # whalebrews = [ ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}