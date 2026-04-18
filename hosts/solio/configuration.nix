{ config, ... }:
{
  imports = [
    ../darwin/nix.nix
    ../darwin/homebrew.nix
    ../darwin/system.nix
    ../darwin/user.nix
    ../darwin/shells.nix
    ../darwin/services.nix
  ];

  networking.hostName = "solio";

  # Enable sudo authentication with Apple Watch
  security.pam.services.sudo_local.watchIdAuth = true;

  homebrew.casks = [
    "libreoffice"
    "openemu"
  ];

  system.configurationRevision = config.rev or config.dirtyRev or null;
  system.stateVersion = 6;
}
