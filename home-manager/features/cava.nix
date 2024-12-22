{ lib, pkgs, ... }:
{
  programs.cava = {
    enable = true;
    settings =
      { }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        # Relies on having Background Music installed!
        # Done in hosts/darwin for each host
        # <https://github.com/karlstav/cava?tab=readme-ov-file#macos-1>
        input = {
          method = "portaudio";
          source = "Background Music";
        };
      };
  };
}
