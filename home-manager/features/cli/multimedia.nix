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
    aria

    # Work with PDFs
    poppler-utils
    exiftool
  ];

  programs = {
    yt-dlp.enable = true;
    feh.enable = true;
  };
}
