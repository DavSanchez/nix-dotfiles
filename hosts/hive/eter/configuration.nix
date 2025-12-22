{
  name,
  config,
  pkgs,
  lib,
  ...
}:
{
  # colmena specifics
  deployment = {
    # No other x86_64 builder yet, so...
    buildOnTarget = true;
    targetHost = "${name}.local";
    targetUser = "david";
    tags = [
      "zima"
      "seclusium"
      "eter"
    ];
  };

  #
  # Normal NixOS configuration starts here.
  #
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./fs_share.nix
    ./zfs.nix
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
    };
    gc = {
      automatic = false; # managed by nh, below
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
    hostName = name;
    firewall.allowedTCPPorts = [
      80
    ]
    ++ lib.optionals config.services.nfs.server.enable [
      111
      2049
      4000
      4001
      4002
      20048
    ];
    firewall.allowedUDPPorts = lib.optionals config.services.nfs.server.enable [
      111
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
    ];
  };
  users.groups = {
    multimedia = { };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
  };

  # Make deployments to this machine passwordless
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    vim
    yazi
    bottom
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
