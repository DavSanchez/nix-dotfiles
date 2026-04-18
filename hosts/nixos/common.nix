{ ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    trusted-users = [
      "root"
      "david"
    ];
    experimental-features = "nix-command flakes";
  };
  nix.optimise.automatic = true;

  time.timeZone = "Atlantic/Canary";
  console.keyMap = "es";

  users.users.david.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvM06bcMBkqNyadDKDGQXl4ztggBM1mgg5/CLqnqNvn davidslt+ssh@pm.me"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVmyCytQRBGJMOdUawPjHZvHGfjovgHdq5o6hjmlW+P davidslt+ssh@pm.me"
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };
}
