_: {
  programs.rio = {
    enable = true;
    settings = {
      theme = "rose-pine-moon";
    };
  };

  xdg.configFile."rio/themes".source = ./themes;
}
