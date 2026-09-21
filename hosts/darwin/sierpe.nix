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
          # Store plus build trees and image scratch (see build-dir below).
          diskSize = 80 * 1024;
          # 64 GB host, no memory balloon driver so this is never reclaimed while the
          # VM runs (only `just stop-linux-builder` gives it back) — spare headroom
          # before builds ever need the disk-backed build-dir below.
          memorySize = 16 * 1024;
        };
        cores = 4;
      };
      # The guest's / is a RAM-backed tmpfs (~half of memorySize) and Nix builds under
      # $TMPDIR by default; /nix/var isn't its own mount, so it's on that tmpfs too —
      # confirmed via `df` inside the guest. /nix/.rw-store is the actual disk-backed
      # mount (the writable overlay layer over the persistent qcow2, per nixpkgs'
      # vz-vm.nix) — build-dir has to live there, not under /nix/var or /nix/store.
      nix.settings.build-dir = "/nix/.rw-store/builds";
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
