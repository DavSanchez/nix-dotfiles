#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${JUST_TRACE:-}" ]]; then set -x; fi

if [[ $# -ne 1 ]]; then
  echo "usage: host-key.sh <host>" >&2
  exit 2
fi
host=$1

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root"

dir="$repo_root/local/host-keys"
key="$dir/${host}.ed25519"
mkdir -p "$dir"
if [[ -e "$key" ]]; then
  echo "reusing existing $key" >&2
else
  ssh-keygen -t ed25519 -N "" -C "$host host key" -f "$key"
fi

recipient="$(nix run --inputs-from . nixpkgs#ssh-to-age -- -i "$key.pub")"
printf '\nage recipient for %s: %s\n\n' "$host" "$recipient"
echo "Add it to .sops.yaml (both the top-level 'keys:' list and the"
echo "'creation_rules' age list), then run: just update-sops"
