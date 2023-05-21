{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.services.newrelic-infra;
  yamlFormat = pkgs.formats.yaml {};
in {
  options.services.newrelic-infra = {
    enable = lib.mkEnableOption "newrelic-infra service";
    config = lib.mkOption {
      type = yamlFormat.type;
      default = {};
      example = lib.literalExpression ''
        license_key: "YOUR_LICENSE_KEY"
        display_name: "YOUR_HOSTNAME"
      '';
      description = "Infrastructure Agent configuration. Refer to <https://docs.newrelic.com/docs/infrastructure/install-infrastructure-agent/configuration/infrastructure-agent-configuration-settings> for details on supported values.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.newrelic-infra = {
      description = "New Relic Infrastructure Agent";

      after = [
        "dbus.service"
        "syslog.target"
        "network.target"
      ];

      serviceConfig = {
        RuntimeDirectory = "newrelic-infra";
        Type = "simple";
        ExecStart = "${pkgs.infrastructure-agent}/bin/newrelic-infra-service";
        MemoryMax = "1G";
        Restart = "always";
        RestartSec = 20;
        PIDFile = "/run/newrelic-infra/newrelic-infra.pid";
      };

      unitConfig = {
        StartLimitInterval = 0;
        StartLimitBurst = 5;
      };

      wantedBy = ["multi-user.target"];
    };

    environment.etc."newrelic-infra.yml".source = yamlFormat.generate "newrelic-infra.yml" cfg.config;
  };
}
