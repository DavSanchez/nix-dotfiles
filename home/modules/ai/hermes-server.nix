# The always-on Hermes backend: gateway (Telegram/Discord/Slack, ...) plus
# the backend that Hermes Desktop connects to. "dashboard" is a strict
# superset of "serve" (same /api/ws + /api/pty sockets, plus the browser
# admin panel on the same port) — worth having since host stays 127.0.0.1,
# so it adds no exposure, just a browser fallback when the desktop app isn't
# installed/reachable.
{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ ./hermes-common.nix ];

  sops.secrets."hermes/desktop_token" = { };

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    # TODO: remove once NousResearch/hermes-agent#102142 / #100585 land —
    # upstream py-modules omits these two modules from the sealed venv, so
    # the backend crashes at startup with ModuleNotFoundError. Shim carries
    # them on PYTHONPATH until an input bump ships the fix.
    extraPythonPackages = [
      (
        let
          hpkgs = inputs.hermes-agent.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        in
        hpkgs.python312.pkgs.toPythonModule (
          hpkgs.runCommand "hermes-state-shim" { } ''
            mkdir -p $out/${hpkgs.python312.sitePackages}
            cp ${inputs.hermes-agent}/hermes_state_holders.py $out/${hpkgs.python312.sitePackages}/
            cp ${inputs.hermes-agent}/hermes_state_registry.py $out/${hpkgs.python312.sitePackages}/
          ''
        )
      )
    ];
    backend = {
      mode = "dashboard";
      host = "127.0.0.1";
      port = 9119;
      sessionTokenFile = config.sops.secrets."hermes/desktop_token".path;
    };
  };
}
