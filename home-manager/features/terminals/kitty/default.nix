{ pkgs, ... }:
{
  xdg.configFile."kitty/themes/rose-pine-moon.conf".source = ./rose-pine-moon.conf;
  xdg.configFile."kitty/kitty.app.png".source = ./kitty.app.png;

  programs = {
    kitty = {
      enable = true;
      settings = {
        # shell = "/bin/bash --login";
        font_family = "JetBrainsMono Nerd Font Mono";
        font_size = 14;
        # macos_show_window_title_in = "none";
        hide_window_decorations = if pkgs.stdenv.isDarwin then "titlebar-only" else "no";
      };
      extraConfig = ''
        include themes/rose-pine-moon.conf
      '';
    };
  };
}
