{ lib, pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      sniffnet
      transmission_4
      # zotero
      # mtr-gui # Already using mtr
      czkawka # Multi functional app to find duplicates, empty folders, similar images etc
      zathura
      imhex
      discord

    ])
    ++ lib.optionals pkgs.stdenv.isDarwin (
      with pkgs;
      [
        utm
        chatgpt
        iina
      ]
    )
    ++ lib.optionals pkgs.stdenv.isLinux (
      with pkgs;
      [
        handbrake
        gqrx
        vlc
        sonic-pi
        # logseq
        # anytype # P2P note-taking app
        # yacreader
      ]
    );
}
