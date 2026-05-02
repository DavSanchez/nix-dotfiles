{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    protonmail-desktop
  ];

  programs.himalaya = {
    enable = true;
    # settings = { };
  };

  services.protonmail-bridge = {
    enable = pkgs.stdenv.isLinux;
  };
}
