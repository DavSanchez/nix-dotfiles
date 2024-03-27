# Colmena functions take `name` and `nodes` as arguments as well.
{
  name,
  nodes,
  config,
  lib,
  pkgs,
  ...
}: {
  # Colmena specifics
  deployment = {
    targetHost = "${name}.local";
    targetUser = "david";
    tags = ["raspberrypi" "monitor"];
  };

  #
  # Normal NixOS configuration starts here.
  #
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    hostName = name;
    wireless = {
      enable = true;
      environmentFile = "/home/david/secrets/wireless.env";
      networks."TP-Link_89F4".psk = "@HALL_PASS@";
      interfaces = ["wlan0"];
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [80];
    };
  };

  # Set your time zone.
  time.timeZone = "Atlantic/Canary";

  nix = {
    settings = {
      trusted-users = ["root" "david"];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  environment.systemPackages = with pkgs; [vim];

  users = {
    users.david = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvM06bcMBkqNyadDKDGQXl4ztggBM1mgg5/CLqnqNvn davidslt+ssh@pm.me"
      ];
      extraGroups = ["wheel"];
    };
  };
  # Make deployments to this machine passwordless
  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  # Expose the hostname
  # Publish this server and its address on the network
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # grafana configuration
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "${name}.local";
      http_port = 2342;
      http_addr = "127.0.0.1";
      root_url = "http://${name}.local/grafana/";
      serve_from_sub_path = true;
    };
  };
  # nginx reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."${name}.local" = {
      locations."/grafana/" = {
        proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };
  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = name;
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
              "${nodes.foundry-pi.name}.local:${toString nodes.foundry-pi.services.prometheus.exporters.node.port}"
            ];
          }
        ];
      }
    ];
  };

  programs.nix-ld.enable = true;

  system.stateVersion = "24.05";
}
