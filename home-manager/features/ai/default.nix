{ config, ... }:
{
  # Starting simple
  services = {
    ollama.enable = true;
  };

  programs = {
    codex.enable = true;

    gemini-cli = {
      enable = true;
      settings = {
        security = {
          auth = {
            selectedType = "oauth-personal";
          };
        };
        general = {
          previewFeatures = true;
          preferredEditor = "hx";
        };
      };
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
