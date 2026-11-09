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

    shell = lib.mkOption {
      type = with lib.types; nullOr (listOf str);
      default = null;
      example = [ "nu" ];
      description = ''
        Command that new terminals and kept-terminal recovery start. The first
        element is the executable and the rest are its arguments; add `-l` for
        a login shell. Written to {option}`settings`.shell.

        When unset, herdr-core starts the machine's own shell ({env}`SHELL` on
        Unix, PowerShell 7 on Windows when available). This is read by the
        core, so it applies to every client using it, including terminals the
        desktop app opens.

        Requires herdr-core 0.1.16 or newer. Older cores ignore the key, so
        the shell keeps coming from whatever environment started the core.
      '';
    };

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
        and `hc --help` for the available keys (`shell`, `shell_mode`,
        `wait_timeout`, `notes`, …).

        This is separate from {option}`programs.herdr.settings` (the TUI at
        {file}`$XDG_CONFIG_HOME/herdr/config.toml`) and
        {option}`programs.herdr.desktop.settings` (the app at
        {file}`$XDG_CONFIG_HOME/herdr-app/settings.json`).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # The core only reads this key, but an older core silently ignores it and
    # keeps the launch environment's shell. Warn while that is the case.
    warnings = lib.optional (cfg.shell != null && lib.versionOlder cfg.package.version "0.1.16") ''
      programs.herdr.core.shell requires herdr-core 0.1.16 or newer, but
      programs.herdr.core.package is ${cfg.package.version}. That version
      ignores the `shell` key, so terminals keep using the shell inherited
      from the environment that started the core. Update the package (see
      NixOS/nixpkgs#584646) or override programs.herdr.core.package.
    '';

    home.packages = [ cfg.package ];

    programs.herdr.core.settings = lib.mkIf (cfg.shell != null) {
      shell = lib.mkDefault cfg.shell;
    };

    xdg.configFile."herdr-core/config.toml" = lib.mkIf (cfg.settings != { }) {
      source = settingsSource;
    };
  };
}
