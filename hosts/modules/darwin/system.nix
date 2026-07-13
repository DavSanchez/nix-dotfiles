{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ vim ];

  system.primaryUser = "david";
  system.defaults.dock.autohide = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
}
