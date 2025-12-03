{
  name,
  config,
  ...
}:
{
  # grafana configuration
  services.grafana = {
    enable = true;
    settings.server = {
      http_port = 2342;
      http_addr = "127.0.0.1";
      root_url = "http://${name}.local/grafana/";
      serve_from_sub_path = true;
    };
  };
  # nginx reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."${name}.local" = {
      locations = {
        # These require that each application sets its "base URL" config to the same path
        "/grafana/" = {
          proxyPass = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        "/prometheus/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        # "/transmission/" = {
        #   proxyPass = "http://127.0.0.1:9091";
        #   proxyWebsockets = true;
        #   recommendedProxySettings = true;
        # };
        "/qbittorrent/" = {
          proxyPass = "http://127.0.0.1:8080";
          recommendedProxySettings = true;
        };
        "/radarr/" = {
          proxyPass = "http://127.0.0.1:7878";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        "/lidarr/" = {
          proxyPass = "http://127.0.0.1:8686";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        "/sonarr/" = {
          proxyPass = "http://127.0.0.1:8989";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        "/prowlarr/" = {
          proxyPass = "http://127.0.0.1:9696";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };
  services.prometheus = {
    enable = true;
    port = 9001;
    webExternalUrl = "http://${name}.local/prometheus/";
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
