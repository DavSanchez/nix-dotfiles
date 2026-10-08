{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  # Agent CLIs that nixpkgs does not carry. Taken from llm-agents' own package
  # set: this flake does not follow that input, so these build against the
  # nixpkgs revision it pins, not ours.
  agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
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
          toast.delivery = "system";
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
      # llama-cpp # broken for now (nodejs)
      llama-swap
      python313Packages.huggingface-hub

      llm
    ])
    ++ (with agents; [
      autolith
      prime-agent
    ]);
}
