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
    yt-dlp = {
      enable = true;
      package =
        if pkgs.stdenv.isDarwin then
          pkgs.yt-dlp.overridePythonAttrs (o: {
            # don't use gnome keyring
            dependencies = (
              __filter (
                p:
                !(__elem p.pname [
                  "cffi"
                  "secretstorage"
                ])
              ) o.dependencies
            );
          })
        else
          pkgs.yt-dlp;
    };
    feh.enable = true;
    rtorrent.enable = true;
  };
}
