# Observability for the lab: Prometheus + Grafana on mora, scraping the
# node_exporter on every host (hosts/nixos/modules/node-exporter.nix and
# hosts/darwin/modules/prometheus-node.nix) over Tailscale MagicDNS.
#
# Grafana is reachable at https://grafana.mora.davidslt.es on the tailnet and on
# the LAN (the LiveDNS A record carries both the 192.168 and 100.64/10 addresses).
{
  config,
  ...
}:
let
  domain = "mora.davidslt.es";

  # Keep in sync with hosts/nixos/modules/node-exporter.nix.
  nodeExporterPort = 9100;
  prometheusPort = 9001;
  grafanaPort = 2342;
in
{
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = prometheusPort;

    # 30 days, capped so a runaway can't fill mora's SD card. Scraping every
    # minute rather than the 15s default also cuts the write amplification.
    retentionTime = "30d";
    extraFlags = [ "--storage.tsdb.retention.size=5GB" ];
    globalConfig = {
      scrape_interval = "1m";
      evaluation_interval = "1m";
    };

    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [ { targets = [ "127.0.0.1:${toString prometheusPort}" ]; } ];
      }
      {
        job_name = "mora";
        static_configs = [ { targets = [ "127.0.0.1:${toString nodeExporterPort}" ]; } ];
      }
    ]
    # The other lab hosts, by Tailscale MagicDNS name.
    ++
      map
        (host: {
          job_name = host;
          static_configs = [ { targets = [ "${host}:${toString nodeExporterPort}" ]; } ];
        })
        [
          "eter"
          "bruma"
          "duende"
          "sierpe"
          "solio"
        ];
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = grafanaPort;
        domain = "grafana.${domain}";
        root_url = "https://grafana.${domain}/";
      };
      # Grafana's file provider keeps the values out of the world-readable store:
      # only the path is in grafana.ini, the secrets are read at startup.
      security = {
        admin_password = "$__file{${config.sops.secrets.grafana_admin_password.path}}";
        secret_key = "$__file{${config.sops.secrets.grafana_secret_key.path}}";
      };
      analytics.reporting_enabled = false;
      users.allow_sign_up = false;
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          uid = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:${toString prometheusPort}";
          isDefault = true;
          editable = false;
        }
      ];
      dashboards.settings.providers = [
        {
          name = "default";
          orgId = 1;
          folder = "";
          type = "file";
          disableDeletion = false;
          updateIntervalSeconds = 60;
          options.path = ./dashboards;
        }
      ];
    };
  };

  services.caddy.virtualHosts."grafana.${domain}" = {
    useACMEHost = domain;
    extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString grafanaPort}
    '';
  };

  sops.secrets = {
    grafana_admin_password = {
      owner = "grafana";
    };
    grafana_secret_key = {
      owner = "grafana";
    };
  };
}
