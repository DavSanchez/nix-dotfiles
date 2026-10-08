#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${JUST_TRACE:-}" ]]; then set -x; fi

if [[ $# -ne 1 ]]; then
  echo "usage: inject-pi-host-key.sh <work-directory>" >&2
  exit 2
fi

work=$1
cd "$work" || exit

debugfs -w -R "write hostkey /ssh-host-key" root.img >/dev/null
debugfs -w -R "sif /ssh-host-key mode 0100600" root.img >/dev/null
debugfs -w -R "sif /ssh-host-key uid 0" root.img >/dev/null
debugfs -w -R "sif /ssh-host-key gid 0" root.img >/dev/null

# debugfs exits 0 even when a request fails, so check the result explicitly.
debugfs -R "cat /ssh-host-key" root.img 2>/dev/null | cmp -s - hostkey ||
  { echo "error: host key was not written to the image" >&2; exit 1; }
stat_out="$(debugfs -R "stat /ssh-host-key" root.img 2>/dev/null)"
if ! grep -qE 'Mode:[[:space:]]+0600' <<<"$stat_out" ||
  ! grep -qE 'User:[[:space:]]+0[[:space:]]+Group:[[:space:]]+0[[:space:]]' <<<"$stat_out"; then
  echo "error: host key in the image has wrong mode/owner (want 0600 root:root)" >&2
  exit 1
fi
