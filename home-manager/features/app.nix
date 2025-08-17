{ lib, pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      # sniffnet
      # handbrake
      # logseq
      # gqrx
      # vlc
      # transmission
      # yacreader
      # zotero
      # sonic-pi
      # mtr-gui
      czkawka # Multi functional app to find duplicates, empty folders, similar images etc
      zathura

      # anytype # P2P note-taking app
    ])
    ++ lib.optionals pkgs.stdenv.isDarwin [ pkgs.utm ]
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.imhex ];
}
