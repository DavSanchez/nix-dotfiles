{
  config,
  ...
}:
let
  domain = "mora.davidslt.es";
in
{
  services.caddy.enable = true;

  # ACME certificate via DNS-01 (Gandi)
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme.2yrzm@mail.davidslt.es";
    certs."${domain}" = {
      inherit domain;
      group = config.services.caddy.group;
      dnsProvider = "gandiv5";
      # The secret eter uses for its Gandi DNS-01 certs. `gandi_pat` is declared
      # in ./livedns.nix.
      environmentFile = config.sops.secrets.gandi_pat.path;
      extraDomainNames = [
        "grafana.${domain}"
      ];
    };
  };

  # Firewall: HTTP/S for Caddy
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
