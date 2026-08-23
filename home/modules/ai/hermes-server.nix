# The always-on Hermes backend: gateway (Telegram/Discord/Slack, ...) plus
# the backend that Hermes Desktop connects to. "dashboard" is a strict
# superset of "serve" (same /api/ws + /api/pty sockets, plus the browser
# admin panel on the same port) — worth having since host stays 127.0.0.1,
# so it adds no exposure, just a browser fallback when the desktop app isn't
# installed/reachable.
#
# This module turns ON the `services.hermes-agent` daemon (state, config and
# the gateway/backend launchd agents). It is imported only by the host that
# should actually run the service — solio. Hosts that want just the CLI /
# desktop import `hermes-common.nix` instead, which provides the programs
# without enabling any daemon.
{
  config,
  ...
}:
{
  imports = [ ./hermes-common.nix ];

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    backend = {
      mode = "dashboard";
      host = "127.0.0.1";
      port = 9119;
      # Let Hermes Desktop connect to this backend instead of starting a
      # second one. The token is a sops runtime path (never a Nix store
      # path), so only the owning user can read it.
      sessionTokenFile = config.sops.secrets."hermes/desktop_token".path;
    };
  };
}
