_:
{
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
      # "anytype"
      # "background-music"
      # "bartender"
      "brave-browser"
      "claude"
      "crossover"
      "gqrx"
      "handbrake-app"
      "helium-browser"
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
      "thaw"
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
      "Tampermonkey" = 6738342400;
      "The Unarchiver" = 425424353;
      "uBlock Origin Lite" = 6745342698;
      "UTM" = 1538878817;
      "Windows App" = 1295203466;
    };
  };
}
