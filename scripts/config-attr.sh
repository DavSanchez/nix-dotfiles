#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${JUST_TRACE:-}" ]]; then set -x; fi

if [[ $# -ne 1 ]]; then
  echo "usage: config-attr.sh <config>" >&2
  exit 2
fi
config=$1

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root"

has() {
  [[ "$(nix eval --json ".#$1" --apply "c: builtins.hasAttr \"$config\" c" 2>/dev/null)" == true ]]
}

if has nixosConfigurations; then
  printf 'nixosConfigurations.%s' "$config"
elif has darwinConfigurations; then
  printf 'darwinConfigurations.%s' "$config"
elif has homeConfigurations; then
  printf 'homeConfigurations."%s"' "$config"
else
  printf 'error: config %s not found in this flake\n' "$config" >&2
  exit 1
fi
