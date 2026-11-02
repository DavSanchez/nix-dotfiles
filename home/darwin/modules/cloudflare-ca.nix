{
  config,
  lib,
  pkgs,
  ...
}:
let
  bundle = "${config.home.homeDirectory}/.claude/cloudflare-gateway-ca.pem";

  # Export the Cloudflare Gateway CA(s) from the System keychain. Writes
  # atomically and keeps the previous bundle if the lookup yields nothing.
  refresh = pkgs.writeShellScript "refresh-cloudflare-ca" ''
    set -eu
    mkdir -p "$(dirname ${bundle})"
    tmp="$(mktemp "${bundle}.XXXXXX")"
    trap 'rm -f "$tmp"' EXIT
    /usr/bin/security find-certificate -a -c "Cloudflare" -p \
      /Library/Keychains/System.keychain > "$tmp" || true
    if [ -s "$tmp" ]; then
      mv "$tmp" ${bundle}
    fi
  '';
in
{
  # Node ignores the macOS keychain, so trust the Cloudflare Gateway CA
  # explicitly (reaches zsh, bash, fish and nushell via `home.sessionVariables`).
  home.sessionVariables.NODE_EXTRA_CA_CERTS = bundle;

  # The CA can be rotated, so refresh the bundle at login and once a day.
  launchd.agents.cloudflare-ca = {
    enable = true;
    config = {
      ProgramArguments = [ "${refresh}" ];
      RunAtLoad = true;
      StartInterval = 86400;
    };
  };

  # Have the bundle in place right after a switch, without waiting for launchd.
  home.activation.cloudflareCa = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${refresh} || true
  '';
}
