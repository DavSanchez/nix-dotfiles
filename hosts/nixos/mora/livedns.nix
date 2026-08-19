{ config, ... }:
{
  imports = [
    ../modules/gandi-livedns.nix
  ];

  services.gandi-livedns = {
    enable = true;
    tokenFile = config.sops.secrets.gandi_pat.path;
    domain = "davidslt.es";
    subdomain = [
      "mora"
      "*.mora"
    ];
    interval = "30m";
  };

  sops.secrets.gandi_pat = { };
}
