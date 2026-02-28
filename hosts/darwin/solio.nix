{ config, ... }:
{
  imports = [ ./common.nix ];

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
