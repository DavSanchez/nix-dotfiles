{ config, lib, ... }:
{
  services = {
    plex = {
      enable = true;
      openFirewall = true;
    };

    # Movies
    radarr = {
      enable = true;
      openFirewall = true;
    };

    # Music
    lidarr = {
      enable = true;
      # user = "david";
      openFirewall = true;
    };

    # Books
    readarr = {
      enable = false;
      openFirewall = true;
    };

    # Subtitles
    bazarr = {
      enable = false;
      openFirewall = true;
    };

    transmission = {
      enable = true;
      openFirewall = true;
    };
  };

  # User and groups setup
  users.users =
    lib.optionalAttrs config.services.transmission.enable {
      transmission.extraGroups = [
        "multimedia"
        (lib.optionalString config.services.plex.enable config.services.plex.group)
        (lib.optionalString config.services.radarr.enable config.services.radarr.group)
        (lib.optionalString config.services.lidarr.enable config.services.lidarr.group)
        (lib.optionalString config.services.readarr.enable config.services.readarr.group)
        (lib.optionalString config.services.bazarr.enable config.services.bazarr.group)
      ];
    }
    // lib.optionalAttrs config.services.radarr.enable {
      radarr.extraGroups = [
        "multimedia"
        (lib.optionalString config.services.transmission.enable config.services.transmission.group)
        (lib.optionalString config.services.plex.enable config.services.plex.group)
      ];
    }
    // lib.optionalAttrs config.services.lidarr.enable {
      lidarr.extraGroups = [
        "multimedia"
        (lib.optionalString config.services.transmission.enable config.services.transmission.group)
        (lib.optionalString config.services.plex.enable config.services.plex.group)
      ];
    }
    // lib.optionalAttrs config.services.readarr.enable {
      readarr.extraGroups = [
        "multimedia"
        (lib.optionalString config.services.transmission.enable config.services.transmission.group)
      ];
    }
    // lib.optionalAttrs config.services.bazarr.enable {
      bazarr.extraGroups = [
        "multimedia"
        (lib.optionalString config.services.transmission.enable config.services.transmission.group)
        (lib.optionalString config.services.plex.enable config.services.plex.group)
      ];
    };
}
