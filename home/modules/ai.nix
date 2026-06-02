{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  # Starting simple
  services = {
    ollama.enable = true;
  };

  programs = {
    codex = {
      enable = true;
    };
    claude-code = {
      enable = true;
    };

    opencode = {
      enable = true;
      settings = {
        autoupdate = false;
        plugin = [ "opencode-gemini-auth@latest" ];
      };
    };
  };

  home.packages =
    with pkgs;
    [
      llama-cpp
      llama-swap
      python313Packages.huggingface-hub

      llm
    ]
    ++ (with inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}; [
      full
      # desktop # not yet ready
    ]);
}
