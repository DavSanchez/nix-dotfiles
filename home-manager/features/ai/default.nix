_: {
  # Starting simple
  services = {
    ollama.enable = true;
  };

  programs = {
    codex.enable = true;
    gemini-cli.enable = true;
    opencode = {
      enable = true;
      settings = {
        theme = "catppuccin";
        autoshare = false;
      };
    };

    mcp = {
      enable = true;
      servers = {
        anytype = {
          command = "anytype-mcp";
          env = {
            OPENAPI_MCP_HEADERS = "{\"Authorization\":\"Bearer {env:ANYTYPE_API_KEY}\", \"Anytype-Version\":\"2025-11-08\"}-";
          };
        };
      };
    };
  };
}
