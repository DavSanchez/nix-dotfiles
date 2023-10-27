{pkgs, ...}: {
  services = {
    sketchybar = {
      enable = true;
      config = {};
      extraPackages = [
        pkgs.sketchybar-app-font
      ];
    };
  };
}
