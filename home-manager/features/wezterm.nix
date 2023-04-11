{pkgs, ...}: {
  home.packages = with pkgs; [
    wezterm
  ];

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'

      return {
        font_size = 14,
        color_scheme = 'Synthwave (Gogh)', -- Argonaut, Chalk, TokyoNightStorm (Gogh)...
        window_background_opacity = 0.95,
        hide_tab_bar_if_only_one_tab = true,
        window_close_confirmation = 'NeverPrompt',
        term = "wezterm",
      }
    '';
  };
}
