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

  # OpenCode 2 reads terminal settings from cli.json and ignores the tui.json
  # that OpenCode 1 used. Catppuccin's home-manager module still targets
  # tui.json, so pick its built-in theme names from the global flavour instead.
  opencodeTheme =
    if config.catppuccin.flavor == "frappe" then
      "catppuccin-frappe"
    else if config.catppuccin.flavor == "macchiato" then
      "catppuccin-macchiato"
    else
      "catppuccin";
  opencodeThemeMode = if config.catppuccin.flavor == "latte" then "light" else "dark";
in
{
  # The catppuccin OpenCode module only sets programs.opencode.tui, which
  # OpenCode 2 ignores; the theme is selected through cli below.
  catppuccin.opencode.enable = false;

  services.ollama.enable = true;

  programs = {
    codex.enable = false;
    claude-code.enable = true;

    opencode = {
      enable = true;
      settings.autoupdate = false;
      # OpenCode 2 reads terminal settings from cli.json. Home Manager owns that
      # file here, so use Ctrl+P's settings dialog as a preview and persist any
      # change in this attrset (the file itself is a read-only store symlink).
      cli = {
        theme = {
          name = opencodeTheme;
          mode = opencodeThemeMode;
        };
        animations = true;
        diffs.wrap = "word";
        session = {
          sidebar = "auto";
          scrollbar = false;
          thinking = "hide";
        };
        # Herdr's integration writes this entry; keep it declarative so the
        # agent-state/resume plugin still loads.
        plugins = [ "./herdr-opencode" ];
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
      // lib.optionalAttrs config.programs.nushell.enable {
        terminal = {
          default_shell = "nu";
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
