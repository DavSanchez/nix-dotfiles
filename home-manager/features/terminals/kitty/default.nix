{ pkgs, ... }:
{
  xdg.configFile."kitty/kitty.app.png".source = ./kitty.app.png;

  programs = {
    kitty = {
      enable = true;
      settings = {
        font_family = "Iosevka Term Custom";
        font_size = 14;
        # macos_show_window_title_in = "none";
        hide_window_decorations = if pkgs.stdenv.isDarwin then "titlebar-only" else "no";

        background_opacity = "0.75";
        background_blur = "16";
      };

      shellIntegration = {
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
    };
  };
}
