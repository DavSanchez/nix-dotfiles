_: {
  services = {
    # discoverability with `hostname.local`
    avahi = {
      enable = true;
      settings.publish = {
        disable-publishing = false;
        publish-addresses = true;
        publish-workstation = true;
      };
    };
    tailscale = {
      enable = true;
    };
  };
}
