{ inputs, pkgs, lib, ... }:
{
  # Starting simple
  services = {
    ollama.enable = true;
  };

  programs = {
    codex = {
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

  home.packages =
    with pkgs;
    [
      llama-cpp
      llama-swap
      python313Packages.huggingface-hub

      llm
      inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      jan
    ];
}
