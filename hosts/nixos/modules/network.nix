_: {
  services = {
    # discoverability with `hostname.local`
    avahi = {
      enable = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };
    tailscale = {
      enable = true;
    };
  };
}
