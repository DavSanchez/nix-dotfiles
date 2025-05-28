{ config, lib, ... }:
{
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
    settings =
      {
        ui.pane_frames.rounded_corners = true;
      }
      # Let's use fish as the default shell (if enabled)
      // lib.optionalString config.programs.fish.enable {
        default_shell = "${config.programs.fish.package}/bin/fish";
      };
  };

  # Creating .config/zellij/layouts overwrites
  # the default config location for mac, hence
  # we create the config file here as well
  # xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
