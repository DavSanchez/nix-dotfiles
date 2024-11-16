{
  name,
  nodes,
  config,
  ...
}:
{
  # grafana configuration
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "${name}.local";
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
        "/grafana/" = {
          proxyPass = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        "/prometheus/" = {
          proxyPass = "http://127.0.0.1:${config.services.prometheus.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        "/transmission/" = {
          proxyPass = "http://127.0.0.1:9091";
          proxyWebsockets = true;
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
        "/prowlarr/" = {
          proxyPass = "http://127.0.0.1:9696";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        "/navidrome/" = {
          proxyPass = "http://127.0.0.1:${config.services.navidrome.settings.Port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };
  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
      exportarr-radarr.enable = false;
      exportarr-lidarr = {
        enable = true;
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
