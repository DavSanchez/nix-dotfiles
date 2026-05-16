{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = with inputs.nixos-raspberrypi.nixosModules; [
    usb-gadget-ethernet
    raspberry-pi-5.base
    raspberry-pi-5.bluetooth
    raspberry-pi-5.page-size-16k
    raspberry-pi-5.display-vc4 # "regular" display connected

    inputs.sops-nix.nixosModules.sops
    inputs.hermes-agent.nixosModules.default

    ./modules/nixos/deploy.nix
    ./modules/nixos/locale.nix
    ./modules/nixos/network.nix
    ./modules/nixos/nix.nix
    ./modules/nixos/ssh.nix
    ./modules/nixos/user.nix

    ./mora/services.nix
  ];

  networking = {
    hostName = "mora";
    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.dome_wifi.path;
      networks."TP-Link_83A4".pskRaw = "ext:dome_psk";
    };
  };

  users.users.david = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      helix
      bottom
      broot
    ];
  };

  programs.yazi.enable = false;

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

  boot.loader.raspberry-pi.bootloader = "kernel";

  system.nixos.tags = [
    "raspberry-pi-${config.boot.loader.raspberry-pi.variant}"
    config.boot.loader.raspberry-pi.bootloader
    config.boot.kernelPackages.kernel.version
  ];

  services = {
    hermes-agent = {
      enable = true;
      settings.model.default = "qwen/qwen3.6-plus";
      environmentFiles = [ config.sops.secrets."hermes/mora/env".path ];
      addToSystemPackages = true;
    };
  };

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      dome_wifi = { };
      "hermes/mora/env" = { };
    };
  };

  system.stateVersion = "25.11";
}
