{ pkgs, ... }:
{
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
        plugin = [ "opencode-gemini-auth@latest" ];
      };
    };

    aichat = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    llama-cpp
    python313Packages.huggingface-hub
  ];
}
