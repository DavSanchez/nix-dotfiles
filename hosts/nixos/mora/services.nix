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
      # Commented out: these two keys have no equivalent in `secrets.yaml` (nothing else
      # in the repo uses them), and sops' build-time manifest check rejected the config
      # because of them. Restore together with the declarations at the bottom once the
      # keys exist.
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
      # The secret `eter` uses for its own Gandi DNS-01 certs: a file holding
      # GANDIV5_PERSONAL_ACCESS_TOKEN=…, which is also what gandi-livedns reads.
      environmentFile = config.sops.secrets.gandi_pat.path;
      extraDomainNames = [ "radicle.${domain}" ];
    };
  };

  # Firewall: HTTP/S for Caddy
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Secrets required by this module. `gandi_pat` is declared by ./livedns.nix (and used
  # by eter) — declaring it again here would only duplicate it.
  sops.secrets = {
    # The radicle keys go here once that service is ready, and then the two lines that
    # reference them above come back too:
    # "radicle/mora/pub_key" = { };
    # "radicle/mora/priv_key" = { };
  };
}
