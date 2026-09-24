# Prometheus node_exporter, scraped by mora's Prometheus over Tailscale.
# The port is only opened on the tailnet interface, so the exporter is not
# exposed on the LAN or the public internet.
_: {
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = [ "systemd" ];
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 9100 ];
}
