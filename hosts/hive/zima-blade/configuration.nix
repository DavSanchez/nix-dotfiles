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

  # ZFS
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false;
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  # Accessible via network
  services.nfs.server.enable = true;
  # Enable mail notifications
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      port = 465;
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      tls = "on";
      auth = "login";
      tls_starttls = "off";
    };
    accounts = {
      default = {
        host = "mail.example.com"; # CHANGEME
        passwordeval = "cat /etc/emailpass.txt";
        user = "user@example.com"; # CHANGEME
        from = "user@example.com"; # CHANGEME
      };
    };
  };
  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = [
      # "root"
      "zimazfszed.jc5ka@passmail.net"
    ];
    ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
    ZED_EMAIL_OPTS = "@ADDRESS@";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;

    ZED_USE_ENCLOSURE_LEDS = true;
    ZED_SCRUB_AFTER_RESILVER = true;
  };
  services.zfs.zed.enableMail = false;

  networking = {
    # Required for ZFS
    hostId = "bfbc2f21";
    hostName = "zima-blade";
    firewall.allowedTCPPorts = [
      80
      2049 # NFSv4
    ];
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
