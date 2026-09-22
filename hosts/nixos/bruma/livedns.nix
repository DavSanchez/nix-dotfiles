# See hosts/nixos/modules/gandi-livedns.nix: with tailscale enabled (modules/network.nix)
# this publishes `bruma` / `*.bruma` under davidslt.es to the host's private and
# Tailscale IPs, so services can be reached over the tailnet without a static IP.
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
      "bruma"
      "*.bruma"
    ];
    interval = "30m";
  };

  sops.secrets.gandi_pat = { };
}
