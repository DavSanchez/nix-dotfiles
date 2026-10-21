{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  # Agent CLIs that nixpkgs does not carry. autolith builds against the nixpkgs
  # its own flake pins; prime-agent against ours, since llm-agents follows it.
  system = pkgs.stdenv.hostPlatform.system;
in
{
  services.ollama.enable = true;

  programs = {
    codex.enable = false;
    claude-code.enable = true;

    opencode = {
      enable = true;
      settings.autoupdate = false;
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
      # llama-cpp # broken for now (nodejs)
      llama-swap
      python313Packages.huggingface-hub

      llm
    ])
    ++ [
      inputs.autolith.packages.${system}.default
      inputs.llm-agents.packages.${system}.prime-agent
    ];
}
