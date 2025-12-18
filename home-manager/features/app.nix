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
      raycast
      alt-tab-macos
    ];

    # This depends on having `raycast` installed. See `home.packages` above.
    launchd.agents.raycast = {
      enable = true;
      config = {
        Program = builtins.toString (
          lib.path.append (
            /. + config.home.homeDirectory
          ) "Applications/Home Manager Apps/Raycast.app/Contents/MacOS/Raycast"
        );
        RunAtLoad = true;
      };
    };

    # This depends on having `alt-tab-macos` installed. See `home.packages` above.
    launchd.agents.alt-tab = {
      enable = true;
      config = {
        Program = builtins.toString (
          lib.path.append (
            /. + config.home.homeDirectory
          ) "Applications/Home Manager Apps/AltTab.app/Contents/MacOS/AltTab"
        );
        RunAtLoad = true;
      };
    };
  })
]
