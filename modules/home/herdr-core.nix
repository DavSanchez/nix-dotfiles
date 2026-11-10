{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.herdr.core;

  tomlFormat = pkgs.formats.toml { };
  settingsSource = tomlFormat.generate "herdr-core-config.toml" cfg.settings;
in
{
  options.programs.herdr.core = {
    enable = lib.mkEnableOption "herdr-core (the Herdr terminal daemon and the hc CLI)";

    package = lib.mkPackageOption pkgs "herdr-core" { };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      example = {
        shell = [
          "nu"
          "-l"
        ];
      };
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/herdr-core/config.toml`.

        herdr-core only reads this file (it never writes it), so unlike the
        desktop app's settings there is no mutable mode. See the core's README
        and `hc --help` for the available keys (`shell`, `wait_timeout`,
        `notes`, …).

        This is separate from {option}`programs.herdr.settings` (the TUI at
        {file}`$XDG_CONFIG_HOME/herdr/config.toml`) and
        {option}`programs.herdr.desktop.settings` (the app at
        {file}`$XDG_CONFIG_HOME/herdr-app/settings.json`).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."herdr-core/config.toml" = lib.mkIf (cfg.settings != { }) {
      source = settingsSource;
    };
  };
}
