{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops

    ./modules/nixos/deploy.nix
    ./modules/nixos/locale.nix
    ./modules/nixos/network.nix
    ./modules/nixos/nix.nix
    ./modules/nixos/ssh.nix
    ./modules/nixos/user.nix

    ./eter/hardware-configuration.nix
    ./eter/fs_share.nix
    ./eter/zfs.nix
    ./eter/monitoring.nix
    ./eter/media.nix
    ./eter/livedns.nix
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

  environment.systemPackages = with pkgs; [
    bottom
    helix
  ];

  programs.yazi.enable = true;

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      zfs_mail_pass_file = { };
      acme_gandi_env_file = { };
      lidarr_api_key_file = { };
    };
  };

  system.stateVersion = "23.11";
}
