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

    ./duende/livedns.nix
  ];

  networking = {
    hostName = "duende";
    # No Ethernet run to wherever this sits next to the TV, so Wi-Fi is the only link.
    # duende sits on the hall AP (`TP-Link_0498`) with its own `hall_wifi` sops secret,
    # not the shared `dome_wifi`; the age identity is baked into the SD image by
    # `just host-key duende` + `just sd-image duende`, so it associates on the first boot.
    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.hall_wifi.path;
      networks."TP-Link_0498".pskRaw = "ext:hall_psk";
    };
  };

  # 1 GB of RAM (same as bruma) — the gaming specialisation runs cage +
  # RetroArch locally, so compression helps when it is active.
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
    secrets.hall_wifi = {
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
