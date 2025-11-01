{
  name,
  config,
  lib,
  pkgs,
  ...
}:
{
  services = {
    plex = {
      enable = false;
      openFirewall = true;
      dataDir = "/seclusium/imagery/plex";
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
      dataDir = "/seclusium/zg/jellyfin";
    };

    # Movies
    radarr = {
      enable = true;
      dataDir = "/seclusium/imagery/radarr/.config/Radarr";
    };

    # Series
    sonarr = {
      enable = true;
      dataDir = "/seclusium/imagery/sonarr/.config/Sonarr";
    };

    # Music
    lidarr = {
      enable = true;
      dataDir = "/seclusium/echoes/lidarr/.config/Lidarr";
    };

    # Books
    readarr = {
      enable = false;
    };

    # Subtitles
    bazarr = {
      enable = false;
    };

    # Indexers
    prowlarr = {
      enable = true;
    };

    transmission = {
      enable = true;
      package = pkgs.transmission_4;
      home = "/seclusium/zg/transmission";
      openPeerPorts = true;
      openRPCPort = true;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist = "192.168.*.* 127.0.0.1";
        rpc-host-whitelist = "${name}.local";
      };
      webHome = pkgs.flood-for-transmission;
    };

    navidrome = {
      enable = false;
      settings = {
        MusicFolder = "/seclusium/echoes/apple_music/Music";
        DataFolder = "/seclusium/echoes/navidrome";
        BaseURL = "/navidrome";
      };
    };
  };

  # Navidrome can use it
  environment.systemPackages = lib.optionals config.services.navidrome.enable [
    pkgs.ffmpeg
  ];

  # User and groups setup
  users.users =
    lib.optionalAttrs config.services.jellyfin.enable {
      jellyfin.extraGroups = [
        "multimedia"
      ];
    }
    // lib.optionalAttrs config.services.plex.enable {
      plex.extraGroups = [
        "multimedia"
      ];
    }
    // lib.optionalAttrs config.services.transmission.enable {
      transmission.extraGroups = [
        "multimedia"
      ];
    }
    // lib.optionalAttrs config.services.radarr.enable {
      radarr.extraGroups = [
        "multimedia"
      ];
    }
    // lib.optionalAttrs config.services.sonarr.enable {
      sonarr.extraGroups = [
        "multimedia"
      ];
    }
    // lib.optionalAttrs config.services.lidarr.enable {
      lidarr.extraGroups = [
        "multimedia"
      ];
    }
    // lib.optionalAttrs config.services.readarr.enable {
      readarr.extraGroups = [
        "multimedia"
      ];
    }
    // lib.optionalAttrs config.services.bazarr.enable {
      bazarr.extraGroups = [
        "multimedia"
      ];
    }
    // lib.optionalAttrs config.services.navidrome.enable {
      navidrome.extraGroups = [
        "multimedia"
      ];
    };
}
