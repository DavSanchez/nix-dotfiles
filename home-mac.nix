{ pkgs, ... }:

{
  imports = [
    ./modules/app-mac.nix
    ./modules/nu/default-mac.nix
    ./modules/mac-symlink-apps.nix
    ./modules/dev/colima.nix
  ];
}
