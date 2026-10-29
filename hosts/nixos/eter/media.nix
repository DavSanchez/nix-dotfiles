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

      # Transcode segments (HLS) are written here while a stream is playing.
      # The default /var/cache/jellyfin lands on the 26 GiB root eMMC, which is
      # slow for sustained writes, shares the device with swap, and had reached
      # 88% full with 5 GiB of leftover segments. Keep them on the pool next to
      # the rest of Jellyfin's state; the module adds RequiresMountsFor for it.
      cacheDir = "/seclusium/zg/jellyfin/cache";

      # The Celeron N3450's HD 500 iGPU can decode H.264, 8-bit HEVC and VP9 and
      # encode H.264 through VAAPI. It cannot decode 10-bit HEVC or encode HEVC,
      # so 4K HDR still needs direct play (or a faster machine).
      hardwareAcceleration = {
        enable = true;
        type = "vaapi";
        device = "/dev/dri/renderD128";
      };

      # Make Nix the source of truth for encoding.xml; with
      # forceEncodingConfig = false the existing dashboard file would be kept
      # and these settings silently ignored. Dashboard transcoding changes are
      # overwritten on restart.
      forceEncodingConfig = true;
      transcoding = {
        enableHardwareEncoding = true;
        hardwareDecodingCodecs = {
          h264 = true;
          hevc = true;
          mpeg2 = true;
          vc1 = true;
          vp9 = true;
        };
        # The iGPU has no usable tone mapping; software tone mapping would pin
        # all four cores, and HDR 4K cannot be transcoded on this CPU anyway.
        enableToneMapping = false;
        # Pause ffmpeg once it is ahead of playback instead of pegging the CPU.
        throttleTranscoding = true;
      };
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
          use_jellyfin = true;
        };
        jellyfin = {
          url = "http://127.0.0.1:8096";
          apikey._secret = config.sops.secrets.jellyfin_api_key.path;
          movie_library = [ "Movies" ];
          series_library = [ "Series" ];
          movie_library_ids = [ "f137a2dd21bbc1b99aa5c0f6bf02a805" ];
          series_library_ids = [ "5ddaa59a73205234890fdcfc683e14ed" ];
          update_movie_library = true;
          update_series_library = true;
          refresh_method = "immediate";
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
    prowlarr.enable = true;

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

        # Apple Music is a metadata agent (DB-only, no file writes); add it to
        # the agent chain so it is actually queried. Order is priority.
        Agents = "apple-music,deezer,lastfm";

        # Let the lyrics plugin answer lyric lookups alongside embedded tags.
        LyricsPriority = "embedded,nd-lyrics";

        # Apple Music copies live in music/.apple_music so Lidarr's scanner
        # skips the hidden folder; Navidrome still has to index it.
        Scanner = {
          IgnoreDotFolders = false;
          Schedule = "@every 6h";
        };
      };

      withPlugins = p: [
        p.apple-music
        p.listenbrainz-daily-playlist
        p.lyrics-plugin
      ];
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

  # switch-to-configuration restarts every unit whose file changed, and a
  # nixpkgs bump rewrites the zfs-import/zfs-mount unit files even when the
  # mount configuration is identical. Restarting zfs-import-seclusium.service
  # tears down the pool (the mount units Require it), so for a moment nothing
  # under /seclusium is mounted. Units that only reference a pool path through
  # BindPaths/profileDir don't order themselves against those mounts and can
  # start inside that window: navidrome dies with 226/NAMESPACE on its music
  # bind, while qbittorrent/lidarr would silently write into the root
  # filesystem. The nixpkgs modules only add RequiresMountsFor for the
  # directories systemd manages (StateDirectory uses /var/lib, lidarr's dataDir
  # gets no entry at all), so add the pool paths the services actually use.
  systemd.services = {
    navidrome.unitConfig.RequiresMountsFor = [
      config.services.navidrome.settings.MusicFolder
      config.services.navidrome.settings.DataFolder
    ];
    qbittorrent.unitConfig.RequiresMountsFor = [ config.services.qbittorrent.profileDir ];
    lidarr.unitConfig.RequiresMountsFor = [ config.services.lidarr.dataDir ];
  };

  # Shared media access: one group for every app that touches /seclusium.
  # Jellyfin additionally needs the render/video groups for VAAPI (the module
  # sets DeviceAllow, but the device node still needs Unix permissions).
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
      (name: {
        extraGroups = [
          "multimedia"
        ]
        ++ lib.optionals (name == "jellyfin") [
          "render"
          "video"
        ];
      });
}
