{ ... }:
{
  programs.zellij = {
    enable = true;
    settings = { };
  };

  xdg.configFile."zellij/layouts".source = ./layouts;
  # xdg.configFile."layouts".recursive = true;
}
