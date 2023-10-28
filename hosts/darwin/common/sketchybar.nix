{pkgs, ...}: {
  services = {
    sketchybar = {
      enable = true;
      # config = {};
      extraPackages = [
        # pkgs.sketchybar-app-font # Already in fonts
      ];
    };
  };
  # Make way for the sketchybar
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;
}
