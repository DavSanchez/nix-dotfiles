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

  # Linux builder's performance/tuning settings
  nix.linux-builder = {
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 4;
      };
    };

    # M3 chip or newer?
    # config.virtualisation.vz.nestedVirtualization = true;
  };

  networking =
    let
      name = "sierpe";
    in
    {
      hostName = name;
      computerName = name;
    };

  # Enable sudo authentication with Touch ID
  security.pam.services.sudo_local = {
    reattach = true;
    touchIdAuth = true;
    watchIdAuth = true;
  };

  homebrew.casks = [ "synthesia" ];
  homebrew.masApps = {
    "Shazam" = 897118787;
  };

  system.configurationRevision = config.rev or config.dirtyRev or null;
  system.stateVersion = 6;
}
