_: {
  services = {
    plex = {
      enable = true;
      openFirewall = true;
    };

    # Movies
    radarr = {
      enable = true;
      openFirewall = true;
    };

    # Music
    lidarr = {
      enable = true;
      # user = "david";
      openFirewall = true;
    };

    # Books
    readarr = {
      enable = false;
      openFirewall = true;
    };

    # Subtitles
    bazarr = {
      enable = false;
      openFirewall = true;
    };

    transmission = {
      enable = true;
      openFirewall = true;
    };
  };
}
