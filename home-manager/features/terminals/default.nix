{pkgs, ...}: {
  imports = [
    ./foot.nix
    ./kitty.nix
    ./wezterm.nix # main
  ];

  # home.packages = with pkgs; [
  #   contour
  # ];
}
