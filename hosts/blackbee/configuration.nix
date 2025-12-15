{
  nixos-raspberrypi,
  config,
  pkgs,
  ...
}:
{
  imports = with nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.bluetooth
  ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      trusted-users = [
        "root"
        "david"
      ];
      experimental-features = "nix-command flakes";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
    optimise.automatic = true;
  };

  networking = {
    hostName = "blackbee";
  };

  time.timeZone = "Atlantic/Canary";

  users.users.david = {
    initialPassword = "changeme";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvM06bcMBkqNyadDKDGQXl4ztggBM1mgg5/CLqnqNvn davidslt+ssh@pm.me"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMgJQWw5UU2QSDIgEwwDwISqztyyLyaTTglmnplyx17A davidslt+git@pm.me"
    ];
    packages = with pkgs; [
      helix
      yazi
      bottom
    ];
  };

  services.openssh = {
    enable = true;
    # settings.PermitRootLogin = "no";
    # settings.PasswordAuthentication = false;
  };

  fileSystems = {
    "/boot/firmware" = {
      device = "/dev/disk/by-uuid/2175-794E";
      fsType = "vfat";
      options = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
      ];
    };
    "/" = {
      device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  boot.loader.raspberryPi.bootloader = "kernel";

  system.nixos.tags =
    let
      cfg = config.boot.loader.raspberryPi;
    in
    [
      "raspberry-pi-${cfg.variant}"
      cfg.bootloader
      config.boot.kernelPackages.kernel.version
    ];
}
