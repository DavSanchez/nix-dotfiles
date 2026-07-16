{ inputs, config, ... }:
{
  imports = [
    inputs.self.darwinModules.networking
    inputs.self.darwinModules.stevenblack
    inputs.sops-nix.darwinModules.sops

    ./modules/nix.nix
    ./modules/homebrew.nix
    ./modules/system.nix
    ./modules/user.nix
    ./modules/shells.nix
    ./modules/networking.nix
    ./modules/services.nix
  ];

  networking =
    let
      name = "solio";
    in
    {
      hostName = name;
      computerName = name;
    };

  # Enable sudo authentication with Apple Watch
  security.pam.services.sudo_local.watchIdAuth = true;

  homebrew.casks = [
    "libreoffice"
    "openemu"
  ];

  system.configurationRevision = config.rev or config.dirtyRev or null;
  system.stateVersion = 6;
}
