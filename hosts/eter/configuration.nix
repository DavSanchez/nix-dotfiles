{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../nixos/nix.nix
    ../nixos/locale.nix
    ../nixos/ssh.nix
    ../nixos/user.nix
    ./hardware-configuration.nix
    ./fs_share.nix
    ./zfs.nix
    ./monitoring.nix
    ./media.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    # Required for ZFS
    hostId = "bfbc2f21";
    hostName = "eter";
    firewall.allowedTCPPorts = [
      80
      443
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
  };
  users.groups = {
    multimedia = { };
  };

  # Make deployments to this machine passwordless
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    bottom
    helix
    yazi
  ];

  programs.nix-ld.enable = true;
  programs.direnv.enable = true;

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  services.tailscale = {
    enable = true;
  };

  system.stateVersion = "23.11";
}
