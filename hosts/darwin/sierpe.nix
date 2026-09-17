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
          # Disk holds the store *and*, with build-dir set below, kernel build
          # trees (~6G) and SD-image scratch (~8G).
          diskSize = 80 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 4;
      };
      # The guest's / is a RAM-backed tmpfs (default cap: half its RAM) and Nix
      # unpacks sources and builds under $TMPDIR by default, which the
      # nixos-hardware Raspberry Pi kernel (1.7G source, ~6G build tree) blows
      # straight through. Keep build trees on the store disk.
      nix.settings.build-dir = "/nix/var/nix/builds";
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
