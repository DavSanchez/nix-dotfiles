{
  name,
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
      environmentFile = "/var/lib/caddy/acme-gandi-env";
      extraDomainNames = [ "*.${domain}" ];
    };
  };

  # grafana configuration
  services.grafana = {
    enable = false;
    settings.server = {
      http_port = 2342;
      root_url = "https://grafana.${domain}/";
    };
  };
  # caddy reverse proxy
  services.caddy = {
    enable = true;
    virtualHosts = {
      "grafana.${domain}" = {
        useACMEHost = domain;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}
        '';
      };
      "prometheus.${domain}" = {
        useACMEHost = domain;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString config.services.prometheus.port}
        '';
      };
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
      "flood.${domain}" = {
        useACMEHost = domain;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString config.services.flood.port}
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

  services.prometheus = {
    enable = false;
    port = 9001;
    webExternalUrl = "https://prometheus.${domain}/";
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
      exportarr-radarr.enable = false;
      exportarr-sonarr.enable = false;
      exportarr-lidarr = {
        enable = false;
        apiKeyFile = "/var/lib/lidarr/lidarr.api-key"; # FIXME
      };
      exportarr-readarr.enable = false;
      exportarr-bazarr.enable = false;
      exportarr-prowlarr.enable = false;
    };
    scrapeConfigs = [
      {
        job_name = name;
        static_configs = [
          { targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ]; }
        ];
      }
      # {
      #   job_name = nodes.foundry-pi.config.networking.hostName;
      #   static_configs = [
      #     {
      #       # FIXME: resolve? ${nodes.foundry-pi.config.networking.hostName}.local
      #       targets = [
      #         "192.168.8.224:${toString nodes.foundry-pi.config.services.prometheus.exporters.node.port}"
      #       ];
      #     }
      #   ];
      # }
    ];
  };
}
