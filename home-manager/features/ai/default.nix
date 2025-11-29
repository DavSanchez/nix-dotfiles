{ pkgs, ... }:
{
  # Starting simple
  services.ollama = {
    enable = true;
    package = pkgs.stable-2505.ollama;
  };

  programs.codex = {
    enable = true;
    custom-instructions = "";
    settings = { };
  };

  programs.gemini-cli.enable = true;
}
