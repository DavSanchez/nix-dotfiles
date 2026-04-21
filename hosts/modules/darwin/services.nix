_:
{
  services = {
    tailscale = {
      enable = false; # Using standalone application for now
      overrideLocalDns = false;
    };
    sketchybar.enable = false;
    jankyborders = {
      enable = false; # Called on aerospace startup
      active_color = "0xffe1e3e4";
      inactive_color = "0xff494d64";
    };
  };
}
