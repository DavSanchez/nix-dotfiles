{ ... }:
{
  imports = [ ./common.nix ];

  networking.hostName = "sierpe";

  programs.zsh = {
    enableFastSyntaxHighlighting = true;
    enableAutosuggestions = true;
  };

  # Enable sudo authentication with Touch ID
  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew.casks = [ "synthesia" ];
  homebrew.masApps = {
    "Shazam" = 897118787;
  };
}
