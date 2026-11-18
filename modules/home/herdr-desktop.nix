{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.programs.herdr.desktop;

  # Home Manager ships `programs.herdr` (the TUI) itself; this module only adds
  # the desktop app on top of it. If Home Manager ever grows its own desktop
  # section, this module is redundant — fail the build so it is deleted instead
  # of silently duplicated. Re-declaring an option we own aborts evaluation on
  # its own; this catches an upstream section that adds different options (e.g.
  # `programs.herdr.desktop.theme`).
  ourDesktopOptions = [
    "enable"
    "package"
    "mutableSettings"
    "settings"
  ];
  foreignDesktopOptions =
    if options.programs.herdr ? desktop then
      builtins.filter (name: !(builtins.elem name ourDesktopOptions)) (
        builtins.attrNames options.programs.herdr.desktop
      )
    else
      [ ];

  # catppuccin/nix has no Herdr desktop-app module yet. If one appears (an
  # option like `catppuccin.herdr-desktop`, or `catppuccin.herdr.desktop`), the
  # flake owns the app's theme and the hand-written settings must go. The TUI is
  # excluded on purpose: its `theme.name` is a Herdr built-in preset, not
  # something catppuccin/nix provides.
  catppuccinDesktopOptions =
    if !(options ? catppuccin) then
      [ ]
    else
      let
        isDesktopApp =
          name:
          let
            lower = lib.toLower name;
          in
          lib.hasInfix "herdr" lower && (lib.hasInfix "desktop" lower || lib.hasInfix "app" lower);
        nested = lib.optional (
          options.catppuccin ? herdr
          && builtins.isAttrs options.catppuccin.herdr
          && options.catppuccin.herdr ? desktop
        ) "herdr.desktop";
      in
      builtins.filter isDesktopApp (builtins.attrNames options.catppuccin) ++ nested;

  conflicts =
    lib.optional (foreignDesktopOptions != [ ]) ''
      Home Manager now declares programs.herdr.desktop.${lib.concatStringsSep ", programs.herdr.desktop." foreignDesktopOptions}.
      Delete modules/home/herdr-desktop.nix, its export in modules/home/default.nix and its
      import in home/modules/ai/default.nix, then use the upstream options instead.
    ''
    ++ lib.optional (catppuccinDesktopOptions != [ ]) ''
      catppuccin/nix now declares ${lib.concatStringsSep ", " catppuccinDesktopOptions}, so it can
      theme the Herdr desktop app. Drop the manual settings from
      programs.herdr.desktop.settings in home/modules/ai/default.nix and use the upstream option.
    '';

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
    assertions = map (message: {
      assertion = false;
      inherit message;
    }) conflicts;

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
