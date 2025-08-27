{ pkgs, ... }:
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
      enable = false; # Managed manually for now
      # ...
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

  services.ssh-agent.enable = pkgs.stdenv.isLinux;
  services.gpg-agent = {
    enable = pkgs.stdenv.isLinux;

    enableScDaemon = true;
    defaultCacheTtl = 14400;
    maxCacheTtl = 86400;
    pinentry.package = pkgs.pinentry-curses;
    enableSshSupport = true;
    defaultCacheTtlSsh = 14400;
    maxCacheTtlSsh = 86400;
    sshKeys = null;
  };
  home.file.".gnupg/gpg-agent.conf" = {
    enable = pkgs.stdenv.isDarwin;
    text = ''
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    '';
  };
}
