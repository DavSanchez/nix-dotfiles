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
          # Disk is not what the kernel build ran out of (the store disk was only
          # ~9G/40G used): the guest's / is a RAM-backed tmpfs, and Nix puts build
          # trees under it by default — see build-dir below. This size still
          # matters now that build trees live here: a kernel tree is ~6G and the
          # SD-image assembly needs ~8G of scratch.
          diskSize = 80 * 1024;
          # The VM runs whenever the daemon does (KeepAlive) and has no balloon
          # driver, so every MiB here is one this 16G Mac can't get back — after a
          # build the guest's page cache holds most of it. Stay at 4G and cap the
          # compile jobs below instead; 8G would have been comfortable for the
          # build but pushed this host into swap.
          memorySize = 4 * 1024;
        };
        cores = 4;
      };
      # Nix puts build trees under $TMPDIR (/build on the tmpfs root by default).
      # Keep them on the store disk instead, or kernel/image builds run the
      # RAM-backed root filesystem out of space.
      nix.settings.build-dir = "/nix/var/nix/builds";
      # Remote builds take their job count from the builder, not the client (a
      # `--cores 3` on the client still arrives as the guest's nproc), so this is
      # the knob that caps a kernel compile's peak memory: -j2 needs ~2G, where
      # -j4 peaks around 3G and gets OOM-killed in a 4G guest.
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
