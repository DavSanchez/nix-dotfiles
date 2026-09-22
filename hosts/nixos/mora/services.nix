{
  config,
  ...
}:
let
  domain = "mora.davidslt.es";
in
{
  # Radicle seed node + HTTP gateway
  services = {
    radicle = {
      enable = false; # preparing
      # Not in secrets.yaml yet — restore together with the declarations below.
      # publicKey = config.sops.secrets."radicle/mora/pub_key".path;
      # privateKey = config.sops.secrets."radicle/mora/priv_key".path;
      httpd = {
        enable = true;
        listenPort = 8888; # default 8080 picked by qbittorrent
        aliases = { };
      };
      node.openFirewall = true;
      settings = {
        node = {
          alias = "radicle.${domain}";
          seedingPolicy = {
            # restrictive while we learn the ropes
            default = "block";
            scope = "all";
          };
        };
      };
    };

    # Caddy reverse proxy for radicle-httpd
    caddy = {
      enable = true;
      virtualHosts = {
        "radicle.${domain}" = {
          useACMEHost = domain;
          extraConfig = ''
            reverse_proxy http://127.0.0.1:${toString config.services.radicle.httpd.listenPort}
          '';
        };
      };
    };
  };

  # ACME certificate via DNS-01 (Gandi)
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme.2yrzm@mail.davidslt.es";
    certs."${domain}" = {
      inherit domain;
      group = config.services.caddy.group;
      dnsProvider = "gandiv5";
      # The secret eter uses for its Gandi DNS-01 certs.
      environmentFile = config.sops.secrets.gandi_pat.path;
      extraDomainNames = [ "radicle.${domain}" ];
    };
  };

  # Firewall: HTTP/S for Caddy
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # `gandi_pat` is declared in ./livedns.nix.
  sops.secrets = {
    # radicle keys, once they exist:
    # "radicle/mora/pub_key" = { };
    # "radicle/mora/priv_key" = { };
  };
}
