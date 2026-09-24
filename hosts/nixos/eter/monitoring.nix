{
  config,
  lib,
  ...
}:
let
  # Setting DNS A records on the Gandi for certificate generation and reverse proxy configuration.
  domain = "eter.davidslt.es";

  # Only serve the private LAN and tailnet; anything else is refused, so the
  # media stack stays unreachable even if this host ever gains a public address.
  privateNets = [
    "10.0.0.0/8"
    "172.16.0.0/12"
    "192.168.0.0/16"
    "100.64.0.0/10"
    "127.0.0.1/8"
    "fd7a:115c:a1e0::/48"
  ];
  guardedProxy = upstream: ''
    @untrusted not remote_ip ${lib.concatStringsSep " " privateNets}
    respond @untrusted 403
    reverse_proxy ${upstream}
  '';

  # Reverse-proxy upstreams, keyed by the subdomain they are served on.
  upstreams = {
    qbittorrent = "http://127.0.0.1:${toString config.services.qbittorrent.webuiPort}";
    radarr = "http://127.0.0.1:${toString config.services.radarr.settings.server.port}";
    lidarr = "http://127.0.0.1:${toString config.services.lidarr.settings.server.port}";
    sonarr = "http://127.0.0.1:${toString config.services.sonarr.settings.server.port}";
    prowlarr = "http://127.0.0.1:${toString config.services.prowlarr.settings.server.port}";
    navidrome = "http://127.0.0.1:${toString config.services.navidrome.settings.Port}";
    jellyfin = "http://127.0.0.1:8096";
  };
in
{
  # ACME certificate via DNS-01 challenge (Let's Encrypt + Gandi)
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme.2yrzm@mail.davidslt.es";
    certs."${domain}" = {
      inherit domain;
      group = config.services.caddy.group;
      dnsProvider = "gandiv5";
      environmentFile = config.sops.secrets.gandi_pat.path;
      # `flood` is listed for the Flood Transmission web UI, which has no vhost here.
      extraDomainNames = map (name: "${name}.${domain}") (builtins.attrNames upstreams) ++ [
        "flood.${domain}"
      ];
    };
  };

  # caddy reverse proxy
  services.caddy = {
    enable = true;
    virtualHosts = lib.mapAttrs' (
      name: upstream:
      lib.nameValuePair "${name}.${domain}" {
        useACMEHost = domain;
        extraConfig = guardedProxy upstream;
      }
    ) upstreams;
  };

  # node_exporter is provided by ./modules/node-exporter.nix; the Prometheus
  # server, Grafana and their exporters live on mora (see mora/monitoring.nix).
}
