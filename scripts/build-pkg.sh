#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${JUST_TRACE:-}" ]]; then set -x; fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

nix_args=(--no-link --print-out-paths)
if [[ "${1:-}" == --dry-run ]]; then
  nix_args=(--dry-run)
  shift
fi

if [[ $# -ne 2 ]]; then
  echo "usage: build-pkg.sh [--dry-run] <config> <attr>" >&2
  exit 2
fi
config=$1
attr=$2

repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root"

config_attr="$(bash "$script_dir/config-attr.sh" "$config")"
nix build "${nix_args[@]}" ".#${config_attr}.pkgs.${attr}"
