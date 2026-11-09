{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.herdr.desktop;

  jsonFormat = pkgs.formats.json { };
  generatedSettings = jsonFormat.generate "herdr-app-settings.json" cfg.settings;
  # Match the merger's serialization so unchanged mutable files can be
  # replaced by a store link when mutableSettings is disabled.
  settingsSource = pkgs.runCommand "herdr-app-settings.json" { } ''
    ${lib.getExe pkgs.jaq} -c '.' ${generatedSettings} > "$out"
  '';
  settingsPath = "${config.xdg.configHome}/herdr-app/settings.json";

  mutableSettingsActivation = lib.hm.generators.mkImpureConfigMerger {
    inherit pkgs;
    format = "json";
    empty = "{}";
    jqOperation = "$dynamic * $static";
    path = settingsPath;
    staticSettings = settingsSource;
    mode = "600";
  };
in
{
  imports = [ ./herdr-core.nix ];

  options.programs.herdr.desktop = {
    enable = lib.mkEnableOption "the Herdr desktop app";

    package = lib.mkPackageOption pkgs "herdr-desktop" { };

    mutableSettings = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to merge declared settings into a writable
        {file}`$XDG_CONFIG_HOME/herdr-app/settings.json` during activation,
        preserving settings added by Herdr or the user. Declared values take
        precedence. Removing a declaration does not remove it from the file.
        The default keeps the configuration file immutable. Switching back to
        immutable settings automatically replaces the writable file only when
        it is byte-identical to the declared settings. Changed files use Home
        Manager's normal collision and backup handling. Empty settings leave
        the file unmanaged.
      '';
    };

    settings = lib.mkOption {
      type = jsonFormat.type;
      default = { };
      example = {
        telemetry = false;
        sounds.enabled = true;
      };
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/herdr-app/settings.json`.

        This is the desktop app's own settings file. It is separate from
        {option}`programs.herdr.settings`, which configures the Herdr TUI at
        {file}`$XDG_CONFIG_HOME/herdr/config.toml`. See the app's built-in
        guide (`herdr-app --skill`) for the available keys.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # The app is only a client; herdr-core runs every terminal. It lives in
    # its own module (programs.herdr.core) so the package and config have one
    # home, and the app's `core` setting points at that exact binary instead
    # of whatever core it finds first on PATH/~/.local/bin.
    programs.herdr.core.enable = lib.mkDefault true;

    home.packages = [ cfg.package ];

    programs.herdr.desktop.settings = lib.mkIf config.programs.herdr.core.enable {
      core = lib.mkDefault (lib.getExe' config.programs.herdr.core.package "herdr-core");
    };

    home.activation.herdrDesktopMutableSettings = lib.mkIf (
      cfg.mutableSettings && cfg.settings != { }
    ) (lib.hm.dag.entryAfter [ "linkGeneration" ] mutableSettingsActivation);

    home.activation.herdrDesktopImmutableSettings =
      lib.mkIf (!cfg.mutableSettings && cfg.settings != { })
        (
          lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ] (
            lib.hm.generators.mkImpureConfigCleanup {
              file = config.xdg.configFile."herdr-app/settings.json";
            }
          )
        );

    xdg.configFile."herdr-app/settings.json" = lib.mkIf (!cfg.mutableSettings && cfg.settings != { }) {
      source = settingsSource;
    };
  };
}
