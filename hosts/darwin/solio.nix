{ ... }:
{
  imports = [ ./common.nix ];

  networking.hostName = "solio";

  programs.zsh = {
    enableFzfCompletion = true;
    enableFzfGit = true;
  };

  # Enable sudo authentication with Apple Watch
  security.pam.services.sudo_local.watchIdAuth = true;

  homebrew.casks = [
    "libreoffice"
    "openemu"
  ];
}
