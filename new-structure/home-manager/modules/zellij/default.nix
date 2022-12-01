{
  lib,
  pkgs,
  ...
}: {
  programs.zellij = {
    enable = true;
    # settings = {
    #   ui.pane_frames.rounded_corners = true;
    #     no_pane_frames = true;
    # };
  };
  xdg.configFile."zellij/layouts".source = ./layouts;
  # xdg.configFile."layouts".recursive = true;

  # Creating .config/zellij/layouts overwrites
  # the default config location for mac, hence
  # we create the config file here as well
  xdg.configFile."zellij/config.yaml".source = ./config.yaml;
}
