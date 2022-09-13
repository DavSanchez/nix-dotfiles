{ ... }:
{
  programs.zellij = {
    enable = true;
    settings = { };
  };

  xdg.configFile."layouts".source = ./layouts;
  # xdg.configFile."layouts".recursive = true;
}
