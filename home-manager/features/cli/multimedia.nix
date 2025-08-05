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

    poppler-utils # Work with PDFs
  ];

  programs = {
    yt-dlp.enable = true;
    feh.enable = true;
  };
}
