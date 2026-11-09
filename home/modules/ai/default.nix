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
  imports = [ inputs.self.homeModules.herdr-desktop ];

  services.ollama.enable = true;

  programs = {
    codex.enable = false;
    claude-code.enable = true;

    opencode = {
      enable = true;
      settings.autoupdate = false;
      # OpenCode 2 reads terminal settings from cli.json. Keep this minimal so
      # the built-in defaults apply; only Herdr's plugin entry is required.
      cli = {
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
          # 0.1.10 ignores unknown settings keys; ligatures arrive in 0.1.13
          # (nixpkgs#584646), so this takes effect after the package bump.
          # The throw below is a reminder to drop this comment once that lands.
          font_ligatures = lib.throwIf (lib.versionAtLeast pkgs.herdr-desktop.version "0.1.13") ''
            herdr-desktop is now ${pkgs.herdr-desktop.version}.

            font_ligatures is supported natively; remove the forward-compat
            comment and this throw in home/modules/ai/default.nix (keep
            font_ligatures = true).
          '' true;
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
