_: {
  # xdg.configFile."wezterm/lua/rose-pine.lua".source = ./rose-pine.lua;

  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraConfig = ''
      return {
        font_size = 14,
        window_background_opacity = 0.8,
        hide_tab_bar_if_only_one_tab = true,
        color_scheme = 'Catppuccin Mocha',
        font = wezterm.font 'Iosevka Term Custom',
        -- term = "wezterm",
        -- font = wezterm.font 'JetBrainsMono Nerd Font',
        window_decorations = "RESIZE",
        front_end = "WebGpu",
      }
    '';
  };
}
