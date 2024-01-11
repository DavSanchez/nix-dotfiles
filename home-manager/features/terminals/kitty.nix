{pkgs, ...}: {
  programs = {
    kitty = {
      enable = true;
      settings = {
        # shell = "/bin/bash --login";
        font_family = "JetBrainsMono Nerd Font Mono";
        font_size = 14;
        # macos_show_window_title_in = "none";
        hide_window_decorations =
          if pkgs.stdenv.isDarwin
          then "titlebar-only"
          else "no";
      };
    };
  };
}
