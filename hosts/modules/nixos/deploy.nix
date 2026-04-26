_: {
  # users.users.deploy = {
  #   isNormalUser = true;
  #   description = "System deploy user";
  #   uid = 2000;
  #   extraGroups = [
  #     "wheel"
  #     "sudo"
  #   ];
  #   openssh.authorizedKeys.keys = [
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvM06bcMBkqNyadDKDGQXl4ztggBM1mgg5/CLqnqNvn davidslt+ssh@pm.me"
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVmyCytQRBGJMOdUawPjHZvHGfjovgHdq5o6hjmlW+P davidslt+ssh@pm.me"
  #   ];
  # };

  # services.openssh.settings.AllowUsers = [ "deploy" ];

  # # Enable 'sudo' with SSH key
  # security.pam.sshAgentAuth = {
  #   enable = true;
  # };

  # nix.settings.trusted-users = [ "deploy" ];

  # Make deployments to this machine passwordless
  security.sudo.wheelNeedsPassword = false;
}
