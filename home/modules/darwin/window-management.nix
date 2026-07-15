{
  imports = [
    ./aerospace.nix
  ];

  programs.omniwm = {
    enable = true;
    settings = ./omniwm-settings.toml;
  };

  services.jankyborders = {
    enable = true;
    settings = {
      active_color = "0xffe1e3e4";
      inactive_color = "0xff494d64";
      width = 5.0;
    };
  };
}
