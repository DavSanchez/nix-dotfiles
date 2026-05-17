{ config, ... }:
{
  imports = [
    ../modules/nixos/gandi-livedns.nix
  ];

  services.gandi-livedns = {
    enable = true;
    tokenFile = config.sops.secrets.gandi_livedns_env_file.path;
    domain = "davidslt.es";
    subdomain = [
      "eter"
      "*.eter"
    ];
    interval = "30m";
  };

  sops.secrets.gandi_livedns_env_file = { };
}
