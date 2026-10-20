{
  config,
  lib,
  pkgs,
  ...
}:
let
  qbtConfigDir = "${config.services.qbittorrent.profileDir}/qBittorrent/config";
  qbtCategories = builtins.toJSON {
    lidarr.save_path = "/seclusium/echoes/downloads";
    radarr.save_path = "/seclusium/imagery/downloads";
    "tv-sonarr".save_path = "/seclusium/imagery/downloads";
  };
  qbtCategoriesFile = pkgs.writeText "qbittorrent-categories.json" qbtCategories;
in
{
  systemd.tmpfiles.rules = [
    "d /seclusium/imagery/downloads 2775 qbittorrent multimedia -"
    "d /seclusium/echoes/downloads 2775 qbittorrent multimedia -"
  ];

  systemd.services.qbittorrent = {
    restartTriggers = [ qbtCategories ];
    preStart = ''
      install -m 0664 ${qbtCategoriesFile} ${qbtConfigDir}/categories.json
    '';
    serviceConfig.UMask = "0002";
  };

  services = {
    plex = {
      enable = false;
      dataDir = "/srv/appdata/plex";
    };

    jellyfin = {
      enable = true;
      dataDir = "/seclusium/zg/jellyfin";
    };

    # Movies
    radarr = {
      enable = true;
      dataDir = "/srv/appdata/radarr";
    };
    # Series
    sonarr = {
      enable = true;
      dataDir = "/srv/appdata/sonarr";
    };
    # Music
    lidarr = {
      enable = true;
      dataDir = "/srv/appdata/lidarr";
    };
    # Books
    readarr.enable = false;
    # Subtitles
    bazarr = {
      enable = true;
      dataDir = "/srv/appdata/bazarr";
      settings = {
        general = {
          use_sonarr = true;
          use_radarr = true;
        };
        sonarr = {
          ip = "127.0.0.1";
          port = config.services.sonarr.settings.server.port;
          apikey._secret = config.sops.secrets.sonarr_api_key.path;
        };
        radarr = {
          ip = "127.0.0.1";
          port = config.services.radarr.settings.server.port;
          apikey._secret = config.sops.secrets.radarr_api_key.path;
        };
      };
    };
    # Indexers
    prowlarr = {
      enable = true;
      dataDir = "/srv/appdata/prowlarr";
    };

    transmission = {
      enable = false;
      package = pkgs.transmission_4;
      home = "/seclusium/zg/transmission";
      openPeerPorts = true;
      openRPCPort = true;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist = "192.168.*.* 127.0.0.1";
        rpc-host-whitelist = "eter.local";
      };
      webHome = pkgs.flood-for-transmission;
    };

    qbittorrent = {
      enable = true;
      # The WebUI is served with TLS through Caddy (qbittorrent.eter.davidslt.es);
      # don't also expose the plain-HTTP port on every interface.
      openFirewall = false;
      profileDir = "/seclusium/zg/qbittorrent";
    };

    navidrome = {
      enable = true;
      settings = {
        MusicFolder = "/seclusium/echoes/music";
        DataFolder = "/srv/appdata/navidrome";
      };
    };
  };

  # Navidrome can use it
  environment.systemPackages = lib.optionals config.services.navidrome.enable [
    pkgs.ffmpeg
  ];

  # Writers into the shared media tree need group-write (0002); readers keep
  # their own restrictive umasks. Sonarr/Radarr set 0022 in nixpkgs, so force.
  systemd.services = {
    sonarr.serviceConfig.UMask = lib.mkForce "0002";
    radarr.serviceConfig.UMask = lib.mkForce "0002";
    lidarr.serviceConfig.UMask = "0002";
    bazarr.serviceConfig.UMask = "0002";
  };

  # Shared media access: one group for every app that touches /seclusium.
  users.users =
    lib.genAttrs
      (builtins.filter (name: config.services.${name}.enable) [
        "jellyfin"
        "plex"
        "transmission"
        "qbittorrent"
        "rtorrent"
        "radarr"
        "sonarr"
        "lidarr"
        "readarr"
        "bazarr"
        "navidrome"
      ])
      (_: {
        extraGroups = [ "multimedia" ];
      });
}
