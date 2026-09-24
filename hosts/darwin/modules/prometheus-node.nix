# node_exporter for macOS hosts, scraped by mora's Prometheus over Tailscale
# MagicDNS. There is no NixOS-style firewall handling on Darwin, so incoming
# access is governed by the macOS Application Firewall and Tailscale itself.
_: {
  services.prometheus.exporters.node.enable = true;
}
