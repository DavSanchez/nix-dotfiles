{
  name,
  nodes,
  config,
  pkgs,
  ...
}: {
  # colmena specifics
  deployment = {
    # No other x86_64 builder yet, so...
    buildOnTarget = true;
    targetHost = "${name}.local";
    targetUser = "david";
    tags = ["zima"];
  };

  #
  # Normal NixOS configuration starts here.
  #
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false;

  networking = {
    hostId = "bfbc2f21";
    hostName = "zima-blade";
    firewall.allowedTCPPorts = [80];
  };

  time.timeZone = "Atlantic/Canary";

  console.keyMap = "es";

  users.users.david = {
    isNormalUser = true;
    description = "David";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      # firefox
      # thunderbird
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvM06bcMBkqNyadDKDGQXl4ztggBM1mgg5/CLqnqNvn davidslt+ssh@pm.me"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMgJQWw5UU2QSDIgEwwDwISqztyyLyaTTglmnplyx17A davidslt+git@pm.me"
    ];
  };
  # Make deployments to this machine passwordless
  security.sudo.wheelNeedsPassword = false;

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
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

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
        proxyPass = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
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
            ];
          }
        ];
      }
      {
        job_name = nodes.foundry-pi.config.networking.hostName;
        static_configs = [
          {
            # FIXME: resolve? ${nodes.foundry-pi.config.networking.hostName}.local
            targets = ["192.168.8.224:${toString nodes.foundry-pi.config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
    ];
  };

  system.stateVersion = "23.11";
}
