{
  name,
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # colmena specifics
  deployment = {
    # No other x86_64 builder yet, so...
    buildOnTarget = true;
    targetHost = "${name}.local";
    targetUser = "david";
    tags = [ "zima" ];
  };

  #
  # Normal NixOS configuration starts here.
  #
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./zfs_nfs.nix
    ./monitoring.nix
    ./media.nix
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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    # Required for ZFS
    hostId = "bfbc2f21";
    hostName = "zima-blade";
    firewall.allowedTCPPorts = [
      80
      # NFS
      111
      2049
      4000
      4001
      4002
      20048
    ];
    firewall.allowedUDPPorts = [
      111
      # NFS
      2049
      4000
      4001
      4002
      20048
    ];
  };

  time.timeZone = "Atlantic/Canary";

  console.keyMap = "es";

  users.users.david = {
    isNormalUser = true;
    description = "David";
    extraGroups = [
      "networkmanager"
      "wheel"

      "multimedia"
    ];
    packages = [
      # firefox
      # thunderbird
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvM06bcMBkqNyadDKDGQXl4ztggBM1mgg5/CLqnqNvn davidslt+ssh@pm.me"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMgJQWw5UU2QSDIgEwwDwISqztyyLyaTTglmnplyx17A davidslt+git@pm.me"
    ];
  };
  users.groups = {
    multimedia = { };
  };

  # Make deployments to this machine passwordless
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    vim
    yazi
    devenv # Quickly set up projects in any language
  ];

  programs.nix-ld.enable = true;
  programs.direnv.enable = true;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  system.stateVersion = "23.11";
}
