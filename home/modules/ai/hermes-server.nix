# The always-on Hermes backend: gateway (Telegram/Discord/Slack, ...) plus
# the backend that Hermes Desktop connects to. "dashboard" is a strict
# superset of "serve" (same /api/ws + /api/pty sockets, plus the browser
# admin panel on the same port) — worth having since host stays 127.0.0.1,
# so it adds no exposure, just a browser fallback when the desktop app isn't
# installed/reachable.
{
  config,
  ...
}:
{
  imports = [ ./hermes-common.nix ];

  sops.secrets."hermes/desktop_token" = { };

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    backend = {
      mode = "dashboard";
      host = "127.0.0.1";
      port = 9119;
      sessionTokenFile = config.sops.secrets."hermes/desktop_token".path;
    };
  };
}
