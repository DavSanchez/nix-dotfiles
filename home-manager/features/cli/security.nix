{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    cotp
    # oath-toolkit
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
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        "~/.config/colima/ssh_config" # Colima package (containers)
      ];

      matchBlocks = {
        "github.com" = {
          addKeysToAgent = "yes";
          identityFile = "~/.ssh/id_ed25519";
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          extraOptions = {
            UseKeychain = "yes";
          };
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

  services.ssh-agent.enable = pkgs.stdenv.isLinux; # not available for darwin
  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    defaultCacheTtl = 14400;
    maxCacheTtl = 86400;
    pinentry.package = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-tty;
    enableSshSupport = true;
    defaultCacheTtlSsh = 14400;
    maxCacheTtlSsh = 86400;
    sshKeys = null;
  };
}
