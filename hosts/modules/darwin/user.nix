_: {
  users.users.david = {
    name = "david";
    home = "/Users/david";
  };

  nix.settings.trusted-users = [ "david" ];
}
