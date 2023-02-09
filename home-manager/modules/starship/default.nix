_: {
  programs.starship = {
    enable = true;

    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  xdg.configFile."starship.toml".source = ./starship.toml;
}
