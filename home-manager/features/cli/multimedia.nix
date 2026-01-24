{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Media
    imagemagick
    qrencode
    # zbar # Barcode reading
    # xdot
    ffmpeg

    # Download content from the internet
    aria2
  ];

  programs = {
    yt-dlp.enable = true;
    feh.enable = true;
    rtorrent.enable = true;
  };
}
