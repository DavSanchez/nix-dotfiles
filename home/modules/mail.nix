{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    protonmail-desktop
    protonmail-bridge
  ];

  programs.himalaya = {
    enable = true;
    # setings = { };
  };

  services.protonmail-bridge = {
    enable = pkgs.stdenv.isLinux;
  };
}
