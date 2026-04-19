_: {
  # Starting simple
  services = {
    ollama.enable = true;
  };

  programs = {
    claude-code = {
      enable = true;
    };

    opencode = {
      enable = true;
      settings = {
        autoshare = false;
        plugin = [ "opencode-gemini-auth@latest" ];
      };
    };
  };
}
