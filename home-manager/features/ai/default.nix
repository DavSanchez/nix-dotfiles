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
        theme = "catppuccin";
        autoshare = false;
        plugin = [ "opencode-gemini-auth@latest" ];
      };
    };
  };
}
