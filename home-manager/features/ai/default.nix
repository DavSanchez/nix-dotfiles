_: {
  # Starting simple
  services = {
    ollama.enable = true;
  };

  catppuccin.gemini-cli.enable = false; # settings.json is mutable by the CLI :(
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
