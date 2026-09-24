# Explicit macOS Application Firewall configuration. nix-darwin has no
# declarative per-app allow-list, so the unsigned node_exporter binary is added
# and unblocked during activation; signed software (e.g. the Tailscale app) is
# covered by `allowSignedApp`.
{
  config,
  lib,
  ...
}:
let
  exporter = "${config.services.prometheus.exporters.node.package}/bin/node_exporter";
  socketfilterfw = "/usr/libexec/ApplicationFirewall/socketfilterfw";
in
{
  networking.applicationFirewall = {
    enable = true;
    blockAllIncoming = false;
    allowSigned = true;
    allowSignedApp = true;
    enableStealthMode = true;
  };

  system.activationScripts.prometheusNodeExporterFirewall =
    lib.mkIf config.services.prometheus.exporters.node.enable
      {
        text = ''
          ${socketfilterfw} --add "${exporter}" >/dev/null 2>&1 || true
          ${socketfilterfw} --unblockapp "${exporter}" >/dev/null 2>&1 || true
        '';
      };
}
