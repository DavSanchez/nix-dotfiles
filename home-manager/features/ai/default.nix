_: {
  # Starting simple
  services = {
    ollama.enable = true;
  };

  programs = {

    gemini-cli = {
      enable = true;
      # settings = { };
    };

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
