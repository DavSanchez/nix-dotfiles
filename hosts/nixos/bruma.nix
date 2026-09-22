{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-3

    ./modules/deploy.nix
    ./modules/locale.nix
    ./modules/network.nix
    ./modules/nix.nix
    ./modules/raspberry-pi.nix
    ./modules/ssh.nix
    ./modules/user.nix
  ];

  # Ethernet only for now: Wi-Fi would need a sops secret and this host has none yet,
  # so it is not in `.sops.yaml`.
  networking.hostName = "bruma";

  # 1 GB of RAM is tight for local builds (these normally happen on a builder).
  zramSwap.enable = true;

  users.users.david = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      helix
      bottom
      broot
    ];
  };

  system.nixos.tags = [
    "raspberry-pi-3"
    config.boot.kernelPackages.kernel.version
  ];

  system.stateVersion = "26.05";
}
