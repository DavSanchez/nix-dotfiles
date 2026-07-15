{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      secretspec
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
      settings = {
        keyid-format = "long";
        with-fingerprint = true;
        personal-cipher-preferences = "AES256 AES192";
        personal-digest-preferences = "SHA512 SHA384";
      };
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = [
        "~/.lima/*/ssh.config"
        "~/.ssh/dynamic_ssh_config"
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        "~/.config/colima/ssh_config"
      ];

      settings = {
        "*" = {
          AddKeysToAgent = "yes";
          ServerAliveInterval = 60;
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          UseKeychain = "yes";
        };
        "github.com" = {
          IdentityFile = "~/.ssh/id_ed25519";
        };
      };
    };

    keychain = {
      enable = pkgs.stdenv.isLinux;
      keys = [ "id_ed25519" ];
    };
  };

  services = {
    ssh-agent.enable = pkgs.stdenv.isLinux;
    gpg-agent = {
      enable = true;
      enableScDaemon = true;
      defaultCacheTtl = 1800;
      maxCacheTtl = 3600;
      pinentry.package = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-tty;
      defaultCacheTtlSsh = 1800;
      maxCacheTtlSsh = 3600;
      sshKeys = null;
    };
  };
}
