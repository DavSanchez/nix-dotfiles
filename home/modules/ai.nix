{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  aiPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Starting simple
  services = {
    ollama.enable = true;
  };

  programs = {
    codex = {
      enable = true;
      package = aiPkgs.codex;
    };
    claude-code = {
      enable = true;
      package = aiPkgs.claude-code;
    };

    opencode = {
      enable = true;
      package = aiPkgs.opencode;
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
      # inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default # env broken, awaiting fix
      aiPkgs.hermes-agent
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      jan
    ];
}
