_: {
  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      ui.pane_frames.rounded_corners = true;
      theme = "tokyo-night-storm";
    };
  };
  # xdg.configFile."zellij/layouts".source = ./layouts;
  # xdg.configFile."layouts".recursive = true;

  # Creating .config/zellij/layouts overwrites
  # the default config location for mac, hence
  # we create the config file here as well
  # xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
