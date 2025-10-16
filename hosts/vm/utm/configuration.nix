# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.nix-relic.overlays.additions
    ];

    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  networking.hostName = "nixos-vm";

  boot.loader.systemd-boot.enable = true;

  users.users = {
    david = {
      shell = pkgs.zsh;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAtJ6zSsueNkp3+N+DjXwpXi4Lrq9TYvnfXDGIl1Ccsq davidsanchez@newrelic.com"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvM06bcMBkqNyadDKDGQXl4ztggBM1mgg5/CLqnqNvn davidslt+ssh@pm.me"
      ];
      extraGroups = [
        "wheel"
        "docker"
      ];
    };
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  programs.nix-ld.enable = true;
  programs.zsh.enable = true;

  services.qemuGuest.enable = true;

  system.stateVersion = "23.05";
}
