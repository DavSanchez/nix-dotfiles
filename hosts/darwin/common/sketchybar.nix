{ config, pkgs, ... }:
{
  services = {
    sketchybar = {
      enable = true;
      # config = builtins.readFile ./sketchybarrc;
      extraPackages = with pkgs; [
        sketchybar-app-font
        (nerdfonts.override {
          fonts = [
            "Hack"
          ];
        })
      ];
    };
  };
  # Make way for the sketchybar
  system.defaults.NSGlobalDomain._HIHideMenuBar = config.services.sketchybar.enable;
}
