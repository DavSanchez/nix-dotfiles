{ inputs, config, ... }:
{
  imports = [
    inputs.sops-nix.darwinModules.sops

    ./modules/darwin/nix.nix
    ./modules/darwin/homebrew.nix
    ./modules/darwin/system.nix
    ./modules/darwin/user.nix
    ./modules/darwin/shells.nix
    ./modules/darwin/services.nix
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
