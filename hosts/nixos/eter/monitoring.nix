{
  config,
  ...
}:
let
  # Setting DNS A records on the Gandi for certificate generation and reverse proxy configuration.
  domain = "eter.davidslt.es";
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
      extraDomainNames = [
        "qbittorrent.${domain}"
        "radarr.${domain}"
        "lidarr.${domain}"
        "sonarr.${domain}"
        "prowlarr.${domain}"
        "flood.${domain}"
        "navidrome.${domain}"
        "jellyfin.${domain}"
      ];
    };
  };

  # caddy reverse proxy
  services.caddy = {
    enable = true;
    virtualHosts = {
      "qbittorrent.${domain}" = {
        useACMEHost = domain;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString config.services.qbittorrent.webuiPort}
        '';
      };
      "radarr.${domain}" = {
        useACMEHost = domain;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString config.services.radarr.settings.server.port}
        '';
      };
      "lidarr.${domain}" = {
        useACMEHost = domain;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString config.services.lidarr.settings.server.port}
        '';
      };
      "sonarr.${domain}" = {
        useACMEHost = domain;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString config.services.sonarr.settings.server.port}
        '';
      };
      "prowlarr.${domain}" = {
        useACMEHost = domain;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString config.services.prowlarr.settings.server.port}
        '';
      };
      "navidrome.${domain}" = {
        useACMEHost = domain;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString config.services.navidrome.settings.Port}
        '';
      };
      "jellyfin.${domain}" = {
        useACMEHost = domain;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:8096
        '';
      };
    };
  };

  # node_exporter is provided by ./modules/node-exporter.nix; the Prometheus
  # server, Grafana and their exporters live on mora (see mora/monitoring.nix).
}
