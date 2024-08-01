_: {
  programs.rio = {
    enable = false;
    settings = {
      theme = "rose-pine-moon";
      window = {
        decorations = "Disabled";
        opacity = 0.75;
        blur = true;
      };
      navigation.mode = "Plain";
      fonts.family = "JetBrainsMono Nerd Font";
    };
  };

  xdg.configFile."rio/themes".source = ./themes;
}
