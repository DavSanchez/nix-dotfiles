_: {
  # Starting simple
  services.ollama.enable = false;

  programs.codex = {
    enable = true;
    custom-instructions = "";
    settings = { };
  };

  programs.gemini-cli.enable = true;
}
