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
    ./modules/raspberry-pi.nix
    ./modules/ssh.nix
    ./modules/user.nix

    ./duende/retro-gaming.nix
  ];

  networking = {
    hostName = "duende";
    # No Ethernet run to wherever this sits next to the TV, so Wi-Fi is the only link.
    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.duende_wifi.path;
      # TODO: replace with the real SSID once known.
      networks."REPLACE_ME_SSID".pskRaw = "ext:duende_psk";
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

  # `duende`'s age key (derived from its own SSH host key) has to be added to
  # .sops.yaml after first boot, then `just update-sops` — the same bootstrap gap
  # AGENTS.md documents for mora. The actual PSK is added by hand via `sops
  # secrets/secrets.yaml`, not by an agent.
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.duende_wifi = { };
  };

  system.nixos.tags = [
    "raspberry-pi-3"
    config.boot.kernelPackages.kernel.version
  ];

  system.stateVersion = "25.11";
}
