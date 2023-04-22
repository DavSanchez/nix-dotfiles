{pkgs, ...}: {
  home.packages = with pkgs; [
    ## Media
    imagemagick
    qrencode
    zbar # Barcode reading
    xdot
    ffmpeg
  ];

  programs = {
    yt-dlp.enable = true;
    feh.enable = true;
  };
}
