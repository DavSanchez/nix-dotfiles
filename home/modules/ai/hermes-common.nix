{
  inputs,
  config,
  lib,
  ...
}:
let
  hermesHome = config.services.hermes-agent.hermesHome;
in
{
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age.keyFile = "/Users/david/.config/sops/age/keys.txt";
    secrets."hermes/env" = { };
  };

  # The CLI only. `services.hermes-agent` is deliberately not enabled — that is
  # what keeps Hermes unmanaged. Its activation writes $HERMES_HOME/.managed, and
  # while that marker exists `is_managed()` (hermes_cli/config.py) makes
  # save_config() print an error and return without writing: every runtime config
  # change, `hermes config set`, plugin settings, `hermes gateway install` and
  # the gateway setup wizard are refused or silently dropped.
  #
  # config.yaml therefore belongs to Hermes. It already holds the settings Nix
  # used to assert, because the module's merge left the file on disk.
  programs.hermes-agent.enable = true;

  # ~/.hermes/.env is what the CLI and the gateway read for credentials. Copied
  # at 0600 rather than symlinked into the store, which would be world-readable
  # while this file holds the Telegram token and the provider keys.
  home.activation.hermesEnv = lib.hm.dag.entryAfter [ "sops-nix" ] ''
    install -d -m 0700 ${hermesHome}
    install -m 0600 ${config.sops.secrets."hermes/env".path} ${hermesHome}/.env
  '';

  # The marker is persistent state: nothing removes it when the service stops
  # being declared, and Hermes keeps reporting itself managed until it is gone.
  home.activation.hermesUnmanaged = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -f ${hermesHome}/.managed
  '';
}
