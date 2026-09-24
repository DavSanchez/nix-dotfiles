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
