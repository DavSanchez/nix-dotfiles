{ config, lib, ... }:
{
  programs.zellij = {
    enable = false;
    # enableBashIntegration = true; # For debugging purposes, we leave bash disabled
    enableFishIntegration = true;
    enableZshIntegration = true;
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
