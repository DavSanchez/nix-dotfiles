_: {
  # Starting simple
  services.ollama.enable = true;

  programs.codex = {
    enable = true;
    custom-instructions = "";
    settings = { };
  };
}
