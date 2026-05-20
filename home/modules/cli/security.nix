{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      cotp
      # oath-toolkit
      sops
      age

      proton-pass
      proton-pass-cli
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      proton-vpn
      proton-proton-vpn-cli
    ];

  programs = {
    gpg = {
      enable = true;
      # homedir = "${config.xdg.configHome}/gnupg";
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = [
        "~/.lima/*/ssh.config" # Lima package (VMs)
        "~/.ssh/dynamic_ssh_config"
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        "~/.config/colima/ssh_config" # Colima package (containers)
      ];

      settings = {
        "github.com" = {
          AddKeysToAgent = "yes";
          IdentityFile = "~/.ssh/id_ed25519";
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          UseKeychain = "yes";
        };
      };
    };

    password-store.enable = true;

    keychain = {
      enable = true;

      keys = [
        "id_rsa"
        "id_ed25519"
      ];
    };
  };

  services = {
    ssh-agent.enable = true;
    gpg-agent = {
      enable = true;
      enableScDaemon = true;
      defaultCacheTtl = 14400;
      maxCacheTtl = 86400;
      pinentry.package = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-tty;
      defaultCacheTtlSsh = 14400;
      maxCacheTtlSsh = 86400;
      sshKeys = null;
    };
    proton-pass-agent.enable = false;
    yubikey-agent.enable = false;
  };
}
