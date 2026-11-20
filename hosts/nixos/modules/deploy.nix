_: {
  # Dedicated account for deploy-rs — the `sshUser` in `deploy.nodes`
  # (flake.nix) will point at it once each host has its own deploy key.
  #
  # It is a normal user in `wheel` because the commands deploy-rs runs as it
  # (`activate-rs`, `nix-env`, …) escalate with `sudo -u root`. That sudo is
  # meant to authenticate with the SSH key the client's agent forwards
  # (`security.pam.sshAgentAuth` below) rather than a password, which is why
  # the account needs neither a password nor a NOPASSWD rule.
  #
  # `openssh.authorizedKeys.keys` is empty on purpose: a key gets pinned per
  # host once that host's deploy key (Secure Enclave / YubiKey) exists. Until
  # then the account cannot log in at all — no password, and
  # `services.openssh.settings.PasswordAuthentication` is off in
  # modules/ssh.nix — so creating it now changes nothing on the wire.
  #
  # Deliberately NOT here yet:
  # - `services.openssh.settings.AllowUsers = [ "deploy" ]`
  # - dropping `security.sudo.wheelNeedsPassword` below
  # Both would remove `david` as a way in before `deploy` can log in.
  users.users.deploy = {
    isNormalUser = true;
    description = "deploy-rs deployment user";
    uid = 2000;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ ];
  };

  # `nix copy` runs as the deploy `sshUser`, so it has to be allowed to add
  # paths to the store. `david` is already in this list (modules/user.nix).
  nix.settings.trusted-users = [ "deploy" ];

  # Authenticate `sudo` with the SSH key the client's agent forwards
  # (`sshOpts = [ "-A" ]` in flake.nix) instead of a password or a NOPASSWD
  # rule: pam_ssh_agent_auth matches the offered key against the account's
  # /etc/ssh/authorized_keys.d/<user> (the option's default), which nixpkgs
  # already writes for `users.users.<name>.openssh.authorizedKeys`. Everything
  # else keeps asking for the account's real password.
  #
  # nixpkgs adds `Defaults env_keep+=SSH_AUTH_SOCK` for sudo by itself, so the
  # agent socket survives the escalation.
  security.pam.sshAgentAuth.enable = true;

  # Make deployments to this machine passwordless.
  #
  # TODO: drop this once `security.pam.sshAgentAuth` has been verified against
  # the real hosts; until then deploys still rely on it.
  security.sudo.wheelNeedsPassword = false;
}
