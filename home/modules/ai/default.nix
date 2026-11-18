{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  # Agent CLIs that nixpkgs does not carry. Autolith builds against the nixpkgs
  # its own flake pins.
  system = pkgs.stdenv.hostPlatform.system;

  # Herdr's app themes are plain files beside settings.json. These are the
  # theme-editor exports for the light/dark pair the app uses, not something
  # derived from the catppuccin palette: `selection`/`selected` and the bright
  # ANSI slots are app-specific blends the palette has no direct answer for.
  # The files, their xdg.configFile links and the `theme` setting below are
  # scaffolding until catppuccin/nix can theme the Herdr desktop app;
  # modules/home/herdr-desktop.nix fails the build when that lands.
  herdrThemeFiles = {
    latte = ./herdr-themes/catppuccin-latte.json;
    mocha = ./herdr-themes/catppuccin-mocha.json;
  };
in
{
  imports = [
    inputs.self.homeModules.default-shell
    inputs.self.homeModules.herdr-core
    inputs.self.homeModules.herdr-desktop
  ];

  services.ollama.enable = true;

  # Read-only store links: editing a theme from Herdr's UI afterwards fails
  # instead of silently diverging from this declaration.
  xdg.configFile = lib.optionalAttrs config.catppuccin.enable (
    lib.mapAttrs' (
      flavor: source: lib.nameValuePair "herdr-app/themes/catppuccin-${flavor}.json" { inherit source; }
    ) herdrThemeFiles
  );

  programs = {
    codex.enable = false;
    claude-code.enable = true;

    opencode = {
      enable = true;
      settings.autoupdate = false;
      # OpenCode 2 reads terminal settings from cli.json. Keep this minimal so
      # the built-in defaults apply; only Herdr's plugin entry is required.
      # mutableSettings stays off on purpose: it keeps cli.json a managed
      # symlink, so an edit made from the TUI shows up as an activation
      # collision instead of silently diverging from this declaration.
      cli = {
        plugins = [ "./herdr-opencode" ];
        # Herdr owns window/tab layout; OpenCode's own tab strip duplicates it
        # and makes it ambiguous which layer is switching.
        tabs.mode = "off";
      };
    };

    herdr = {
      enable = true;
      settings = {
        onboarding = false;
        keys.prefix = "ctrl+a"; # default (ctrl+b) clashes with ghostty
        theme.name = "catppuccin";
        experimental.pane_history = false;
        ui = {
          agent_panel_sort = "spaces";
          sound.enabled = true;
          # "terminal" emits an escape sequence that Ghostty turns into a native
          # notification; "system" shells out to osascript/terminal-notifier instead.
          toast.delivery = "terminal";
        };
      }
      // lib.optionalAttrs (config.programs.defaultShell.command != null) {
        terminal.default_shell = config.programs.defaultShell.command;
      };

      # Desktop-app terminals are spawned by herdr-core, whose `settings.shell`
      # is the only place to pin the shell (the app has no setting). It reads
      # the config at startup, so restart the core after a rebuild.
      core = lib.mkIf (config.programs.defaultShell.command != null) {
        settings.shell = config.programs.defaultShell.argv;
      };

      desktop = {
        enable = true;
        mutableSettings = true;
        settings = {
          telemetry = false;
          sounds.enabled = true;
          # Match the terminal font from programs.ghostty. The desktop app has
          # no equivalent for Ghostty's opacity, blur, cursor, shaders, or
          # shell-integration settings.
          font = "Iosevka Term Slab";
          font_size = 14;
          font_ligatures = true;
        }
        // lib.optionalAttrs config.catppuccin.enable {
          # Follow the system appearance, as the imperative settings did.
          theme = {
            light = "catppuccin-latte";
            dark = "catppuccin-mocha";
          };
        };
      };
    };
  };

  home.packages =
    (with pkgs; [
      goose-cli
      llama-cpp
      llama-swap
      python313Packages.huggingface-hub

      llm
    ])
    ++ [
      inputs.autolith.packages.${system}.default
    ];
}
