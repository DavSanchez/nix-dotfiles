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
        # (lib.optionalString config.services.transmission.enable config.services.transmission.group)
      ];
    }
    // lib.optionalAttrs config.services.plex.enable {
      plex.extraGroups = [
        "multimedia"
        # (lib.optionalString config.services.transmission.enable config.services.transmission.group)
        # (lib.optionalString config.services.radarr.enable config.services.radarr.group)
        # (lib.optionalString config.services.sonarr.enable config.services.sonarr.group)
      ];
    }
    // lib.optionalAttrs config.services.transmission.enable {
      transmission.extraGroups = [
        "multimedia"
        # (lib.optionalString config.services.plex.enable config.services.plex.group)
        # (lib.optionalString config.services.jellyfin.enable config.services.jellyfin.group)
        # (lib.optionalString config.services.navidrome.enable config.services.navidrome.group)
        # (lib.optionalString config.services.radarr.enable config.services.radarr.group)
        # (lib.optionalString config.services.sonarr.enable config.services.sonarr.group)
        # (lib.optionalString config.services.lidarr.enable config.services.lidarr.group)
        # (lib.optionalString config.services.readarr.enable config.services.readarr.group)
        # (lib.optionalString config.services.bazarr.enable config.services.bazarr.group)
      ];
    }
    // lib.optionalAttrs config.services.radarr.enable {
      radarr.extraGroups = [
        "multimedia"
        # (lib.optionalString config.services.transmission.enable config.services.transmission.group)
        # (lib.optionalString config.services.plex.enable config.services.plex.group)
        # (lib.optionalString config.services.jellyfin.enable config.services.jellyfin.group)
      ];
    }
    // lib.optionalAttrs config.services.sonarr.enable {
      sonarr.extraGroups = [
        "multimedia"
        # (lib.optionalString config.services.transmission.enable config.services.transmission.group)
        # (lib.optionalString config.services.plex.enable config.services.plex.group)
        # (lib.optionalString config.services.jellyfin.enable config.services.jellyfin.group)
      ];
    }
    // lib.optionalAttrs config.services.lidarr.enable {
      lidarr.extraGroups = [
        "multimedia"
        # (lib.optionalString config.services.transmission.enable config.services.transmission.group)
        # (lib.optionalString config.services.jellyfin.enable config.services.jellyfin.group)
        # (lib.optionalString config.services.plex.enable config.services.plex.group)
        # (lib.optionalString config.services.navidrome.enable config.services.navidrome.group)
      ];
    }
    // lib.optionalAttrs config.services.readarr.enable {
      readarr.extraGroups = [
        "multimedia"
        # (lib.optionalString config.services.transmission.enable config.services.transmission.group)
        # (lib.optionalString config.services.jellyfin.enable config.services.jellyfin.group)
      ];
    }
    // lib.optionalAttrs config.services.bazarr.enable {
      bazarr.extraGroups = [
        "multimedia"
        # (lib.optionalString config.services.transmission.enable config.services.transmission.group)
        # (lib.optionalString config.services.jellyfin.enable config.services.jellyfin.group)
        # (lib.optionalString config.services.plex.enable config.services.plex.group)
      ];
    }
    // lib.optionalAttrs config.services.navidrome.enable {
      navidrome.extraGroups = [
        "multimedia"
        # (lib.optionalString config.services.transmission.enable config.services.transmission.group)
        # (lib.optionalString config.services.jellyfin.enable config.services.jellyfin.group)
        # (lib.optionalString config.services.plex.enable config.services.plex.group)
      ];
    };
}
