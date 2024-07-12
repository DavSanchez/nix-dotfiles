_: {
  xdg.configFile."wezterm/lua/rose-pine.lua".source = ./rose-pine.lua;

  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local theme = require('lua/rose-pine').moon

      return {
        font_size = 14,
        window_background_opacity = 0.8,
        use_fancy_tab_bar = false,
        hide_tab_bar_if_only_one_tab = true,
        colors = theme.colors(),
        window_frame = theme.window_frame(), -- needed only if using fancy tab bar
        -- color_scheme = 'Catppuccin Mocha',
        -- term = "wezterm",
        font = wezterm.font 'JetBrainsMono Nerd Font',
        window_decorations = "RESIZE",
      }
    '';
  };
}
