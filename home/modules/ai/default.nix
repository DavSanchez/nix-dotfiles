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
in
{
  imports = [
    inputs.self.homeModules.default-shell
    inputs.self.homeModules.herdr-core
    inputs.self.homeModules.herdr-desktop
  ];

  services.ollama.enable = true;

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
