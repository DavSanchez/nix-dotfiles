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

  users.users."david".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvM06bcMBkqNyadDKDGQXl4ztggBM1mgg5/CLqnqNvn davidslt+ssh@pm.me"
  ];

  # Performance/tuning settings
  nix.linux-builder = {
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          # Store plus build trees and image scratch (see build-dir below).
          diskSize = 80 * 1024;
          # The VM is always up (KeepAlive) and has no balloon driver, so this is
          # RAM the 16 GB host never gets back; compile jobs are capped below instead.
          memorySize = 4 * 1024;
        };
        cores = 4;
      };
      # The guest's / is a RAM-backed tmpfs (~half of memorySize) and Nix builds under
      # $TMPDIR by default; /nix/var isn't its own mount, so it's on that tmpfs too —
      # confirmed via `df` inside the guest. /nix/.rw-store is the actual disk-backed
      # mount (the writable overlay layer over the persistent qcow2, per nixpkgs'
      # vz-vm.nix) — build-dir has to live there, not under /nix/var or /nix/store.
      nix.settings.build-dir = "/nix/.rw-store/builds";
      # Remote builds take the job count from the builder, not the client, so this is
      # what caps a kernel compile: -j2 ~2G, -j4 ~3G and OOM in a 4G guest.
      nix.settings.cores = 2;
    };
  };

  networking =
    let
      name = "solio";
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

  homebrew.casks = [
    "libreoffice"
    "openemu"
  ];

  system.configurationRevision = config.rev or config.dirtyRev or null;
  system.stateVersion = 6;
}
