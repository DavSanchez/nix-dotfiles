#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${JUST_TRACE:-}" ]]; then set -x; fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

flake=github:DavSanchez/nix-dotfiles

if [[ $# -ne 4 ]]; then
  echo "usage: config-diff.sh <dix|nix-diff> <config> <branch> <base>" >&2
  exit 2
fi
tool=$1
config=$2
branch=$3
base=$4

case "$tool" in
  dix | nix-diff) ;;
  *)
    echo "error: unknown diff tool '$tool' (expected dix or nix-diff)" >&2
    exit 2
    ;;
esac

repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root"

config_attr="$(bash "$script_dir/config-attr.sh" "$config")"
case "$config_attr" in
  homeConfigurations.*) target="${config_attr}.activationPackage" ;;
  *) target="${config_attr}.config.system.build.toplevel" ;;
esac

base_path="$(nix build "${flake}/${base}#${target}" --no-link --print-out-paths)"
branch_path="$(nix build "${flake}/${branch}#${target}" --no-link --print-out-paths)"
"$tool" "$base_path" "$branch_path"
