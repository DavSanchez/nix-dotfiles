{
  inputs,
  pkgs,
  ...
}:
{
  services.ollama.enable = false;

  programs = {
    codex.enable = true;
    claude-code.enable = true;

    opencode = {
      enable = true;
      settings.autoupdate = false;
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
      default
      desktop
    ]);
}
