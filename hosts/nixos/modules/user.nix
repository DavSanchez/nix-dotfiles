_: {
  users.users.david.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvM06bcMBkqNyadDKDGQXl4ztggBM1mgg5/CLqnqNvn davidslt+ssh@pm.me"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVmyCytQRBGJMOdUawPjHZvHGfjovgHdq5o6hjmlW+P davidslt+ssh@pm.me"
  ];

  nix.settings.trusted-users = [
    "david"
  ];
}
