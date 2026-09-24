# Prometheus node_exporter, scraped by mora's Prometheus over Tailscale.
# The port is only opened on the tailnet interface, so the exporter is not
# exposed on the LAN or the public internet.
{ config, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [
    config.services.prometheus.exporters.node.port
  ];
}
