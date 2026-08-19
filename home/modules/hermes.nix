{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/Users/david/.config/sops/age/keys.txt";
    secrets."hermes_env" = { };
  };

  services.hermes-agent = {
    enable = true;
    installPackage = true;

    gateway.enable = true;
    backend = {
      mode = "serve";
      host = "127.0.0.1";
      port = 9119;
    };

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
