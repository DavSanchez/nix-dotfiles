# Colmena functions take `name` and `nodes` as arguments as well.
{
  name,
  nodes,
  config,
  lib,
  pkgs,
  ...
}: {
  # colmena specifics
  deployment = {
    targetHost = "${name}.local";
    targetUser = "david";
    tags = ["raspberrypi" "foundry"];
  };

  #
  # Normal NixOS configuration starts here.
  #
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    hostName = name;
    wireless = {
      enable = true;
      environmentFile = "/home/david/secrets/wireless.env";
      networks."TP-Link_89F4".psk = "@HALL_PASS@";
      interfaces = ["wlan0"];
    };
  };

  # Set your time zone.
  time.timeZone = "Atlantic/Canary";

  nix = {
    settings = {
      trusted-users = ["root" "david"];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  environment.systemPackages = with pkgs; [vim nodejs];

  users = {
    users.david = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvM06bcMBkqNyadDKDGQXl4ztggBM1mgg5/CLqnqNvn davidslt+ssh@pm.me"
      ];
      extraGroups = ["wheel"];
    };
  };
  # Make deployments to this machine passwordless
  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  # Expose the hostname
  # Publish this server and its address on the network
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = ["systemd"];
    openFirewall = true;
    port = 9002;
  };

  programs.nix-ld.enable = true;

  system.stateVersion = "24.05";
}
