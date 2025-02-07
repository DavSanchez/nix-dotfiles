{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      ## Media
      imagemagick
      qrencode
      zbar # Barcode reading
      # xdot
      ffmpeg

      # Download content from the internet
      aria

      spotify-player
    ]
    ++ lib.optionals stdenv.isLinux [
      jellyfin-media-player
    ];

  programs = {
    yt-dlp.enable = true;
    feh.enable = true;
  };
}
