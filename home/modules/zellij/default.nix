{ config, lib, ... }:
{
  programs.zellij = {
    enable = true;

    settings = {
      ui.pane_frames.rounded_corners = true;
    }
    # Let's use nushell as the default shell (if enabled)
    // lib.optionalAttrs config.programs.nushell.enable {
      default_shell = "${config.programs.nushell.package}/bin/nu";
    };
  };

  # Creating .config/zellij/layouts overwrites
  # the default config location for mac, hence
  # we create the config file here as well
  # xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
