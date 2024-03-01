_: {
  programs.rio = {
    enable = true;
    settings = {
      theme = "tokyonight";
    };
  };

  xdg.configFile."rio/themes".source = ./themes;
}
