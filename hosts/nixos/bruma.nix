{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-3
    inputs.sops-nix.nixosModules.sops

    ./modules/deploy.nix
    ./modules/locale.nix
    ./modules/network.nix
    ./modules/nix.nix
    ./modules/node-exporter.nix
    ./modules/raspberry-pi.nix
    ./modules/retro-gaming.nix
    ./modules/ssh.nix
    ./modules/user.nix

    ./bruma/livedns.nix
  ];

  networking = {
    hostName = "bruma";
    # Reuses mora's `dome_wifi` (the shared home PSK, SSID `TP-Link_83A4`); the age
    # identity is baked into the SD image by `just host-key bruma` + `just sd-image
    # bruma`, so it associates on the first boot.
    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.dome_wifi.path;
      networks."TP-Link_83A4".pskRaw = "ext:dome_psk";
    };
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.dome_wifi = {
      owner = "wpa_supplicant";
      group = "wpa_supplicant";
      mode = "0440";
    };
  };

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
