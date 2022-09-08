{ pkgs, ... }:

{
  imports = [
    ./modules/nu/default-mac.nix
    ./modules/mac-symlink-apps.nix
  ];
}
