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
    ./modules/ssh.nix
    ./modules/user.nix

    ./duende/livedns.nix
    ./duende/retro-gaming.nix
  ];

  networking = {
    hostName = "duende";
    # No Ethernet run to wherever this sits next to the TV, so Wi-Fi is the only link.
    # Reuses mora's `dome_wifi` (the shared home PSK, SSID `TP-Link_83A4`); the age
    # identity is baked into the SD image by `just host-key duende` + `just sd-image
    # duende`, so it associates on the first boot.
    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.dome_wifi.path;
      networks."TP-Link_83A4".pskRaw = "ext:dome_psk";
    };
  };

  # 1 GB of RAM (same as bruma) — tighter here since cage + RetroArch run locally.
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

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.dome_wifi = {
      owner = "wpa_supplicant";
      group = "wpa_supplicant";
      mode = "0440";
    };
  };

  system.nixos.tags = [
    "raspberry-pi-3"
    config.boot.kernelPackages.kernel.version
  ];

  system.stateVersion = "26.05";
}
