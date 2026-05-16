{ inputs, config, ... }:
{
  imports = [
    inputs.nixosModules.gandi-ddns
  ];

  services.gandi-ddns = {
    enable = true;
    tokenFile = config.sops.secrets.gandi_ddns_token.path;
    domain = "davidslt.es";
    subdomain = "*.mora";
  };

  sops.secrets.gandi_ddns_token = { };
}
