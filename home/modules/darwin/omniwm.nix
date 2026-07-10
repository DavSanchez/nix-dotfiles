{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.omniwm;
in
{
  options.programs.omniwm = {
    enable = lib.mkEnableOption "OmniWM";

    package = lib.mkPackageOption pkgs "omniwm" { };

    launchd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to manage OmniWM with a launchd agent.";
      };

      keepAlive = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether the launchd agent should be kept alive.";
      };
    };

    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      example = lib.literalExpression ''
        {
          general = {
            updateChecksEnabled = false;
          };
        }
      '';
      description = ''
        OmniWM settings written to
        {file}`$XDG_CONFIG_HOME/omniwm/settings.toml`.
        See <https://github.com/BarutSRB/OmniWM> for configuration details.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "programs.omniwm" pkgs lib.platforms.darwin)
    ];

    home.packages = [ cfg.package ];

    launchd.agents.omniwm = {
      inherit (cfg.launchd) enable;
      config = {
        Program = "${cfg.package}/Applications/OmniWM.app/Contents/MacOS/OmniWM";
        KeepAlive = cfg.launchd.keepAlive;
        RunAtLoad = true;
        StandardOutPath = "/tmp/omniwm.log";
        StandardErrorPath = "/tmp/omniwm.err.log";
      };
    };

    xdg.configFile."omniwm/settings.toml" = lib.mkIf (cfg.settings != { }) {
      source = (pkgs.formats.toml { }).generate "omniwm-settings.toml" cfg.settings;
    };
  };
}
