#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${JUST_TRACE:-}" ]]; then set -x; fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -ne 2 ]]; then
  echo "usage: eval-config.sh <config> <subpath>" >&2
  exit 2
fi
config=$1
subpath=$2

repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root"

config_attr="$(bash "$script_dir/config-attr.sh" "$config")"
nix eval --json ".#${config_attr}.${subpath}"
