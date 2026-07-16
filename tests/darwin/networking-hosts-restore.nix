{ config, ... }:

# Tests that disabling networking options correctly restores /etc/hosts.
#
# When all networking.hosts, networking.extraHosts, and networking.hostFiles
# are empty, the activation script should still run and strip any existing
# Nix-managed block, but should NOT add a new one — effectively restoring
# the original /etc/hosts content.

{
  # Deliberately no networking.hosts, extraHosts, or hostFiles set
  # (tests the "disabled / nothing to add" path)

  test = ''
    echo "checking activation script runs even without host content" >&2
    grep "setting up /etc/hosts" ${config.out}/activate

    echo "checking sed stripping logic is present" >&2
    grep -F "sed '/^# BEGIN Nix-managed\$/,/^# END Nix-managed\$/d'" ${config.out}/activate

    echo "checking original content preservation is in the script" >&2
    grep "hostsOriginal" ${config.out}/activate

    echo "checking restore path writes original back (no Nix block)" >&2
    grep "hostsOriginal.*> /etc/hosts" ${config.out}/activate

    echo "checking Nix-managed markers are NOT written to hosts file" >&2
    if grep -F "printf '# BEGIN Nix-managed\n'" ${config.out}/activate; then
      echo "FAIL: Nix-managed block should not be written when no content" >&2
      exit 1
    fi

    echo "checking Nix-managed END marker is also not written" >&2
    if grep -F "printf '# END Nix-managed\n'" ${config.out}/activate; then
      echo "FAIL: Nix-managed END marker should not be written" >&2
      exit 1
    fi

    echo "ok: restore path verified" >&2
  '';
}
