{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkMerge [
  {
    home.packages = with pkgs;
      [
        element-desktop
        lapce
        # handbrake
        # logseq
        # gqrx
        # vlc
        # transmission
        # yacreader
        # zotero
        # insomnia
        # sonic-pi
        # mtr-gui
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        # iterm2
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        zathura
      ];

    programs = {
      kitty = {
        enable = true;
      };
      alacritty = {
        enable = true;
        settings = {
          shell = {
            # Runs bash by default since zsh is configured to enter tmux automatically
            program = "/bin/bash";
            args = [
              "--login"
              "--interactive"
            ];
          };
        };
      };
    };
  }
  {
    # Symlink macos applications. This does not happen by default.
    # https://github.com/nix-community/home-manager/issues/1341
    home.activation = lib.mkIf pkgs.stdenv.isDarwin {
      copyApplications = let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in
        lib.hm.dag.entryAfter ["writeBoundary"] ''
          baseDir="$HOME/Applications/Home Manager Apps"
          if [ -d "$baseDir" ]; then
            rm -rf "$baseDir"
          fi
          mkdir -p "$baseDir"
          for appFile in ${apps}/Applications/*; do
            target="$baseDir/$(basename "$appFile")"
            $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
            $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
          done
        '';
    };
  }
]
