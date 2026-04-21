{ config, ... }:
{
  imports = [
    ./modules/darwin/nix.nix
    ./modules/darwin/homebrew.nix
    ./modules/darwin/system.nix
    ./modules/darwin/user.nix
    ./modules/darwin/shells.nix
    ./modules/darwin/services.nix
  ];

  networking.hostName = "sierpe";

  # Enable sudo authentication with Touch ID
  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew.casks = [ "synthesia" ];
  homebrew.masApps = {
    "Shazam" = 897118787;
  };

  system.configurationRevision = config.rev or config.dirtyRev or null;
  system.stateVersion = 6;
}
