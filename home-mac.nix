{ pkgs, ... }:

{
  home.homeDirectory = "/Users/david";
  home.username = "david";
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  home.packages = with pkgs; [
    mas
    iterm2
  ];

  imports = [
    ./modules/nu/default-mac.nix
    ./modules/mac-symlink-apps.nix
    ./modules/iterm2.nix
    ./modules/dev/colima.nix
  ];
}