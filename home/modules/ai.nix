{ pkgs, ... }:
{
  services.ollama.enable = true;

  programs = {
    codex.enable = true;
    claude-code.enable = true;

    opencode = {
      enable = true;
      settings.autoupdate = false;
    };

    herdr = {
      enable = true;
      settings.keys.prefix = "ctrl+a"; # default (ctrl+b) clashes with ghostty
    };
  };

  home.packages = with pkgs; [
    # llama-cpp # broken for now (nodejs)
    llama-swap
    python313Packages.huggingface-hub

    llm
  ];
}
