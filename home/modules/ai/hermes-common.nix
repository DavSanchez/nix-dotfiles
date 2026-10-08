{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.hermes-agent.homeManagerModules.default
    # TEMPORARY: needed while we track the v0.22.5 tag — see the file.
    ./hermes-pm-darwin.nix
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
      # This block is deep-merged into the existing config.yaml, so a key
      # removed here survives on disk: every value that used to point at the
      # Nous Portal Tool Gateway is overwritten, never deleted.
      # `use_gateway = false` is that same constraint — it was the legacy
      # spelling of the "Nous Subscription" selection and a stale `true`
      # outranks the provider key (tools/tool_backend_helpers.read_selection).
      # Inference runs on the OpenCode Go subscription; the relay is pinned
      # explicitly because `base_url` cannot be dropped from the merge either.
      model = {
        default = "deepseek-v4.1-flash";
        provider = "opencode-go";
        base_url = "https://opencode.ai/zen/go/v1";
      };

      # OpenCode Go is the primary now and only OpenRouter is kept alongside
      # it, so the chain loses its old opencode-go rung. There is also no
      # managed Tool Gateway left to fall back to: every tool category below
      # names a direct or keyless provider instead.
      fallback_providers = [
        {
          provider = "openrouter";
          model = "~deepseek/deepseek-flash-latest";
        }
      ];

      web = {
        backend = "firecrawl"; # keyless when explicitly selected
        use_gateway = false;
      };
      browser = {
        cloud_provider = "local";
        use_gateway = false;
      };

      tts = {
        provider = "edge";
        use_gateway = false;
      };
      stt = {
        provider = "local";
        use_gateway = false;
      };

      image_gen = {
        provider = "openrouter";
        model = "openai/gpt-image-2.5-flare";
        use_gateway = false;
      };
      video_gen = {
        provider = "openrouter";
        model = "bytedance/seedance-2.0";
        use_gateway = false;
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
