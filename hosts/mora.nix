{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = with inputs.nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.bluetooth

    inputs.sops-nix.nixosModules.sops
    inputs.hermes-agent.nixosModules.default

    ./modules/nixos/nix.nix
    ./modules/nixos/locale.nix
    ./modules/nixos/ssh.nix
    ./modules/nixos/user.nix
  ];

  networking = {
    hostName = "mora";
    wireless.enable = true;
  };

  users.users.david = {
    initialPassword = "changeme";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      helix
      yazi
      bottom
    ];
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

  boot.loader.raspberry-pi.bootloader = "kernel";

  system.nixos.tags = [
    "raspberry-pi-${config.boot.loader.raspberry-pi.variant}"
    config.boot.loader.raspberry-pi.bootloader
    config.boot.kernelPackages.kernel.version
  ];

  services = {
    tailscale = {
      enable = true;
    };

    hermes-agent = {
      enable = true;
      settings.model.default = "anthropic/claude-sonnet-4";
      environmentFiles = [ config.sops.secrets."hermes-env".path ];
      addToSystemPackages = true;
    };
  };

  system.stateVersion = "25.11";
}
