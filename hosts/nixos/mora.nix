{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-5

    inputs.sops-nix.nixosModules.sops

    ./modules/deploy.nix
    ./modules/locale.nix
    ./modules/network.nix
    ./modules/nix.nix
    ./modules/raspberry-pi.nix
    ./modules/ssh.nix
    ./modules/user.nix

    ./mora/services.nix
    ./mora/livedns.nix
  ];

  networking = {
    hostName = "mora";
    # Wi-Fi is the fallback link; the PSK comes from sops.
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

  system.nixos.tags = [
    "raspberry-pi-5"
    config.boot.kernelPackages.kernel.version
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      dome_wifi = { };
    };
  };

  system.stateVersion = "25.11";
}
