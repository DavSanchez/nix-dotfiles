{ config, ... }:

# Tests that the default networking.enableHosts = false state generates NO
# /etc/hosts activation code at all.
#
# This is the safety guarantee: importing the module without explicit opt-in
# must leave /etc/hosts completely untouched. Any other tool (Docker Desktop,
# VPN clients, etc.) can manage the file without interference.

{
  # Deliberately NOT setting networking.enableHosts (defaults to false)

  test = ''
    echo "checking NO /etc/hosts activation code is present" >&2
    if grep "setting up /etc/hosts" ${config.out}/activate 2>/dev/null; then
      echo "FAIL: hosts activation code present despite enableHosts=false" >&2
      exit 1
    fi
    echo "ok: no hosts activation code" >&2

    echo "checking NO Nix-managed markers are written" >&2
    if grep "BEGIN Nix-managed" ${config.out}/activate 2>/dev/null; then
      echo "FAIL: Nix-managed block markers present despite enableHosts=false" >&2
      exit 1
    fi
    echo "ok: no Nix-managed markers" >&2

    echo "checking NO sed stripping logic is present" >&2
    if grep "Nix-managed" ${config.out}/activate 2>/dev/null; then
      echo "FAIL: sed stripping logic present despite enableHosts=false" >&2
      exit 1
    fi
    echo "ok: no sed stripping logic" >&2

    echo "checking NO generated hosts file reference" >&2
    if grep "generatedHosts\|string-hosts\|extra-hosts\|localhost-hosts" ${config.out}/activate 2>/dev/null; then
      echo "FAIL: generated hosts file referenced despite enableHosts=false" >&2
      exit 1
    fi
    echo "ok: no generated hosts references" >&2
  '';
}
