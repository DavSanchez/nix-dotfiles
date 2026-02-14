{
  name,
  config,
  ...
}:
{
  # grafana configuration
  services.grafana = {
    enable = false;
    settings.server = {
      http_port = 2342;
      root_url = "http://${name}.local/grafana/";
      serve_from_sub_path = true;
    };
  };
  # caddy reverse proxy
  services.caddy = {
    enable = true;
    virtualHosts."${name}.local".extraConfig = ''
      reverse_proxy /grafana/* http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}
      reverse_proxy /prometheus/* http://127.0.0.1:${toString config.services.prometheus.port}
      reverse_proxy /qbittorrent/* http://127.0.0.1:${toString config.services.qbittorrent.webuiPort}
      reverse_proxy /radarr/* http://127.0.0.1:${toString config.services.radarr.settings.server.port}
      reverse_proxy /lidarr/* http://127.0.0.1:${toString config.services.lidarr.settings.server.port}
      reverse_proxy /sonarr/* http://127.0.0.1:${toString config.services.sonarr.settings.server.port}
      reverse_proxy /prowlarr/* http://127.0.0.1:${toString config.services.prowlarr.settings.server.port}
      reverse_proxy /flood/* http://127.0.0.1:${toString config.services.flood.port}
      reverse_proxy /navidrome/* http://127.0.0.1:${toString config.services.navidrome.settings.Port}
      reverse_proxy /jellyfin/* http://127.0.0.1:8096
    '';
  };

  services.prometheus = {
    enable = false;
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
