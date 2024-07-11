{ config, lib, ... }:
{
  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      ui.pane_frames.rounded_corners = true;
      theme = "rose-pine-moon"; # "cyber-noir", "darkfox"

      # Let's use fish as the default shell (if enabled)
      default_shell = lib.optionalString config.programs.fish.enable "${config.programs.fish.package}/bin/fish";
    };
  };

  xdg.configFile."zellij/themes" = {
    source = ./themes;
    recursive = true;
  };

  # Creating .config/zellij/layouts overwrites
  # the default config location for mac, hence
  # we create the config file here as well
  # xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
