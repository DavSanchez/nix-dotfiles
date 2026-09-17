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

  # Ethernet (100 Mbit on the 3B) is what the official image brings up on first boot
  # and what `deploy-rs` uses from then on. No sops secrets here yet, so Wi-Fi would
  # need a plaintext PSK; add the host to `.sops.yaml` and its own module when needed.
  networking.hostName = "bruma";

  # The wiki's Raspberry Pi 3 page warns that 512 MB–1 GB of RAM can be exhausted by a
  # large local derivation and suggests "disk or compressed-RAM swap, or an AArch64
  # remote builder": builds happen on a builder (CI's ARM runner) or on a Mac and are
  # copied over by deploy-rs, and this adds the swap side for headroom.
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

  system.stateVersion = "25.11";
}
