{ lib, pkgs, ... }:

lib.mkMerge [
  {
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
    };
  }
  # Until https://github.com/nushell/nushell/issues/893 is solved...
  (lib.mkIf pkgs.stdenv.isDarwin {
    home.file = {
      "Library/Application Support/nushell/config.nu".source = ./config.nu;
      "Library/Application Support/nushell/env.nu".source = ./env.nu;
    };
  })
]
