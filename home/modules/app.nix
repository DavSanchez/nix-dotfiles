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
        imhex
        czkawka # Multi functional app to find duplicates, empty folders, similar images etc
        obsidian-export
        motrix-next # Download manager
      ])
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (
        with pkgs;
        [
          handbrake
          gqrx
          vlc
          sonic-pi
          # logseq
          # yacreader
          # anytype # P2P note-taking app
        ]
      );

    programs = {
      obsidian = {
        enable = true;
        cli.enable = true;
        # vaults are managed outside for now, will think on migration
      };
      zathura.enable = false;
    };
  }
  (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    home.packages = with pkgs; [
      utm
      iina
      # ice-bar # Waiting for Tahoe compat
      stats
    ];
    # Autostart for `stats` is handled in-app via SMAppService ("Launch at
    # login"), not by home-manager-managed launchd agents. This avoids
    # restarts on every `home-manager switch` and lets the app go through
    # LaunchServices on launch.
  })
]
