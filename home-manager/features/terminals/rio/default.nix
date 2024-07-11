_: {
  programs.rio = {
    enable = true;
    settings = {
      theme = "rose-pine-moon";
      window = {
        decorations = "Disabled";
        opacity = 0.75;
        blur = true;
      };
    };
  };

  xdg.configFile."rio/themes".source = ./themes;
}
