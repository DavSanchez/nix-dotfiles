# Colmena functions take `name` and `nodes` as arguments as well.
{
  name,
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  # colmena specifics
  deployment = {
    targetHost = "${name}.local";
    targetUser = "david";
    tags = [
      "raspberrypi"
      "foundry"
    ];
  };

  #
  # Normal NixOS configuration starts here.
  #
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
      interfaces = [ "wlan0" ];
    };
    firewall.allowedTCPPorts = [
      80
      443
    ]; # nginx reverse proxy
  };

  # Set your time zone.
  time.timeZone = "Atlantic/Canary";

  environment.systemPackages = with pkgs; [
    vim
    yazi
    devenv # Quickly set up projects in any language
  ];

  programs.nix-ld.enable = true;
  programs.direnv.enable = true;

  users = {
    users.david = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvM06bcMBkqNyadDKDGQXl4ztggBM1mgg5/CLqnqNvn davidslt+ssh@pm.me"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMgJQWw5UU2QSDIgEwwDwISqztyyLyaTTglmnplyx17A davidslt+git@pm.me"
      ];
      extraGroups = [ "wheel" ];
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

  # nginx reverse proxy
  services.nginx = {
    enable = true;
    virtualHosts."${name}.local" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:30000"; # Foundry VTT
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };

  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    openFirewall = true;
    port = 9002;
  };

  # Foundry VTT server
  systemd.services."foundryvtt" =
    let
      node = "${pkgs.nodejs}/bin/node";
      foundryEntryPoint = "/home/david/foundryvtt/resources/app/main.js";
      foundryData = "/home/david/foundrydata";
    in
    {
      enable = true;
      description = "Foundry VTT service (Node.js)";
      serviceConfig.ExecStart = "${node} ${foundryEntryPoint} --dataPath=${foundryData}";
      wantedBy = [ "multi-user.target" ];
    };

  system.stateVersion = "24.05";
}
