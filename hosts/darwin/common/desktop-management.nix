{pkgs, ...}: {
  services = {
    yabai = {
      enable = true;
      enableScriptingAddition = false; # Requires SIP disabled
      # config = {};
      extraConfig.source = ./yabairc;
    };
    skhd = {
      enable = true;
      skhdConfig.source = ./skhdrc;
    };
    sketchybar = {
      enable = false;
      config = {};
      extraPackages = [
        pkgs.sketchybar-app-font
      ];
    };
  };
}
