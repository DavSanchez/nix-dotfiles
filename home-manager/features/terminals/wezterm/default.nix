_: {
  # xdg.configFile."wezterm/lua/rose-pine.lua".source = ./rose-pine.lua;

  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'

      return {
        font_size = 14,
        window_background_opacity = 0.8,
        hide_tab_bar_if_only_one_tab = true,
        color_scheme = 'Catppuccin Mocha',
        -- term = "wezterm",
        font = wezterm.font 'JetBrainsMono Nerd Font',
        window_decorations = "RESIZE",
      }
    '';
  };
}
