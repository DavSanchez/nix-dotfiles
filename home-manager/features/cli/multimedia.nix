{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      ## Media
      imagemagick
      qrencode
      chafa
      # zbar # Barcode reading
      # xdot
      ffmpeg

      # Download content from the internet
      aria2
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      ctpv
    ];

  programs = {
    yt-dlp.enable = true;
    feh.enable = true;
    rtorrent.enable = true;
  };
}
