{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wezterm
  ];

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
    
      return {
        font_size = 14,
        color_scheme = 'Chalk', -- Chester, Chalk, Ayu Mirage
        window_background_opacity = 0.85,
        hide_tab_bar_if_only_one_tab = true,
      }
    '';
  };

}
