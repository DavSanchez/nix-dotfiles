_: {
  # Starting simple
  services = {
    ollama.enable = true;
  };

  programs = {
    codex.enable = true;

    gemini-cli = {
      enable = true;
      # settings = { };
    };

    opencode = {
      enable = true;
      settings = {
        theme = "catppuccin";
        autoshare = false;
      };
    };
  };
}
