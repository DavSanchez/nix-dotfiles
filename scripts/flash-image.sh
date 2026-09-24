#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${JUST_TRACE:-}" ]]; then set -x; fi

if [[ $# -ne 2 ]]; then
  echo "usage: flash-image.sh <image> <device>" >&2
  exit 2
fi

image=$1
image="${image/#\~/$HOME}"
device=$2

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root" || exit

if [[ "$(uname -s)" != Darwin ]]; then
  echo "error: flash-image is macOS-only — it uses diskutil to identify/unmount the card and /dev/rdiskN to write it" >&2
  echo "       on Linux: 'lsblk' to find the card, then: zstd -dc <image> | sudo dd of=/dev/sdX bs=4M status=progress && sync" >&2
  exit 1
fi

# Also accept the sdImage output directory (e.g. a `nix build -o <host>` symlink):
# the actual image lives under its sd-image/ subdir.
if [[ -d "$image" ]]; then
  resolved="$(find "$image/sd-image" -maxdepth 1 -type f -print -quit 2>/dev/null || true)"
  [[ -n "$resolved" ]] || { echo "error: no image file under $image/sd-image" >&2; exit 1; }
  image=$resolved
fi
[[ -f "$image" ]] || { echo "error: $image is not a file" >&2; exit 1; }

num="${device#/dev/}"
num="${num#rdisk}"
num="${num#disk}"
[[ "$num" =~ ^[0-9]+$ ]] || { echo "error: '$device' is not a disk number, diskN or rdiskN" >&2; exit 1; }
disk="/dev/disk${num}"
rdisk="/dev/rdisk${num}"
[[ -b "$disk" || -c "$disk" ]] || { echo "error: $disk is not a disk device" >&2; exit 1; }

diskutil info "$disk" | grep -E 'Device / Media Name|Volume Name|Disk Size|Removable Media|Whole|Device Location' || true
# `diskutil` pads the values with spaces, so match whitespace, not a single space.
# `Protocol: Secure Digital` covers built-in readers macOS reports as internal.
if ! diskutil info "$disk" | grep -qE 'Removable Media:[[:space:]]*(Removable|Yes)|Ejectable Media:[[:space:]]*(Yes|Ejectable)|Protocol:[[:space:]]*Secure Digital|Virtual:[[:space:]]*Yes|Device Location:[[:space:]]*External'; then
  echo "error: $disk does not look like a removable/external disk — refusing to write it" >&2
  exit 1
fi

echo
echo "About to ERASE $disk and write:"
echo "  $image"
read -r -p 'Type "yes" to continue: ' answer
[[ "$answer" == yes ]] || { echo "aborted"; exit 1; }

diskutil unmountDisk "$disk"
if [[ "$image" == *.zst ]]; then
  if command -v zstd >/dev/null 2>&1; then
    zstd -dc "$image" | sudo dd of="$rdisk" bs=4M
  else
    nix run --inputs-from . nixpkgs#zstd -- -dc "$image" | sudo dd of="$rdisk" bs=4M
  fi
else
  sudo dd if="$image" of="$rdisk" bs=4M
fi
sync
diskutil eject "$disk"
echo "done: $disk"
