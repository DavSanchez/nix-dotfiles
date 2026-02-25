{
  lib,
  pkgs,
  config,
  ...
}:
lib.mkMerge [
  {
    home.packages =
      (with pkgs; [
        sniffnet
        # zotero
        # mtr-gui # Already using mtr
        czkawka # Multi functional app to find duplicates, empty folders, similar images etc
        zathura
        imhex
        discord
      ])
      ++ lib.optionals pkgs.stdenv.isLinux (
        with pkgs;
        [
          handbrake
          gqrx
          vlc
          sonic-pi
          # logseq
          anytype # P2P note-taking app
          # yacreader
        ]
      );
  }
  (lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = with pkgs; [
      utm
      iina
      # ice-bar # Waiting for Tahoe compat
      alt-tab-macos
      stats
    ];

    # This depends on having `alt-tab-macos` installed. See `home.packages` above.
    launchd.agents.alt-tab = {
      enable = true;
      config = {
        Program = toString (
          lib.path.append (
            /. + config.home.homeDirectory
          ) "Applications/Home Manager Apps/AltTab.app/Contents/MacOS/AltTab"
        );
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/alt-tab.log";
        StandardErrPath = "/tmp/alt-tab.err.log";
      };
    };

    # This depends on having `stats` installed. See `home.packages` above.
    launchd.agents.stats = {
      enable = true;
      config = {
        Program = toString (
          lib.path.append (
            /. + config.home.homeDirectory
          ) "Applications/Home Manager Apps/Stats.app/Contents/MacOS/Stats"
        );
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/stats.log";
        StandardErrPath = "/tmp/stats.err.log";
      };
    };
  })
]
