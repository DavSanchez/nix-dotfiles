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
    secrets."hermes_env" = { };
  };

  # The Hermes CLI on PATH (and HERMES_HOME for shells). This is the
  # "programs" half of the split introduced upstream: `services.hermes-agent`
  # now only owns the daemon/state/config, and `programs.hermes-agent.enable`
  # installs the command line. Every host with this module gets the CLI.
  programs.hermes-agent.enable = true;

  services.hermes-agent = {
    environmentFiles = [ config.sops.secrets."hermes_env".path ];

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
    };
  };
}
