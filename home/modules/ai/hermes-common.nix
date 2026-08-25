{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age.keyFile = "/Users/david/.config/sops/age/keys.txt";
    secrets."hermes/env" = { };
  };

  programs.hermes-agent.enable = true;

  # Config only — the service itself is enabled by hermes-server.nix (solio).
  services.hermes-agent = {
    environmentFiles = [ config.sops.secrets."hermes/env".path ];

    settings = {
      model = {
        default = "deepseek/deepseek-v4-flash-0731";
        provider = "nous";
        base_url = "https://inference-api.nousresearch.com/v1";
      };

      web = {
        backend = "firecrawl";
        use_gateway = true;
      };
      browser = {
        cloud_provider = "browser-use";
        use_gateway = true;
      };

      tts = {
        provider = "openai";
        use_gateway = true;
      };
      stt = {
        provider = "openai";
        use_gateway = true;
      };

      image_gen = {
        provider = "fal";
        model = "fal-ai/gpt-image-2";
        use_gateway = true;
      };
      video_gen = {
        provider = "fal";
        model = "seedance-2.0";
        use_gateway = true;
      };

      plugins.enabled = [ "herdr-agent-state" ];

      # Upstream module defaults workingDirectory to $HOME and writes it into
      # config.yaml as terminal.cwd, which pins interactive CLI/TUI sessions
      # to $HOME even when launched from a project directory ("cd is the
      # configuration" — see NousResearch/hermes-agent#19214, #86411).
      # "." is a placeholder: the gateway resolves it per-backend and local
      # sessions fall back to os.getcwd(). Revisit if the solio gateway
      # daemon's Telegram sessions start in a wrong directory.
      terminal.cwd = ".";
    };
  };
}
