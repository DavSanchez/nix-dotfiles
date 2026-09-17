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
          # 4G is not enough: a -j4 kernel compile peaks around 3G (it will get
          # OOM-killed mid-build), and this Mac has 16G total, so 6G is the
          # compromise between build reliability and keeping the host usable.
          memorySize = 6 * 1024;
        };
        cores = 4;
      };
      # Nix puts build trees under $TMPDIR (/build on the tmpfs root by default).
      # Keep them on the store disk instead, or kernel/image builds run the
      # RAM-backed root filesystem out of space.
      nix.settings.build-dir = "/nix/var/nix/builds";
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
