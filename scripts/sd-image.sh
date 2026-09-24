#!/usr/bin/env bash
set -euo pipefail
umask 077

if [[ -n "${JUST_TRACE:-}" ]]; then set -x; fi

if [[ $# -ne 1 ]]; then
  echo "usage: sd-image.sh <host>" >&2
  exit 2
fi

host=$1
case "$host" in
  mora|bruma|duende) ;;
  *)
    printf 'error: unsupported Pi host: %s\n' "$host" >&2
    exit 2
    ;;
esac

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root" || exit

# `system.build.sdImage` is a directory holding the compressed image under
# sd-image/ (plus nix-support/); the pure build itself carries no key.
out="$(nix build --no-link --print-out-paths ".#packages.aarch64-linux.${host}-sd-image")"
image="$(find "$out/sd-image" -maxdepth 1 -type f -print -quit)"
[[ -n "$image" ]] || { echo "error: no image file found under $out/sd-image" >&2; exit 1; }

key="$repo_root/local/host-keys/${host}.ed25519"
if [[ ! -f "$key" ]]; then
  echo "warning: $key not found — the image will generate its host key (and sops age" >&2
  echo "         identity) on first boot; run 'just host-key $host' then" >&2
  echo "         'just update-sops' to pre-seed it before flashing." >&2
  echo "$image"
  exit 0
fi

# Inject the private host key into a copy of the image outside the Nix store
# (see lib/nixos-sd-image.nix): decompress, write /ssh-host-key into the ext4
# root partition with debugfs, then recompress to local/images/.
echo "injecting $key into a non-store copy of the image (SSH host key + sops age identity)" >&2
work="$(mktemp -d)"
output_tmp=""
cleanup() {
  rm -rf "$work"
  if [[ -n "$output_tmp" ]]; then
    rm -rf "$output_tmp"
  fi
}
trap cleanup EXIT

nix run --inputs-from . nixpkgs#zstd -- -dc "$image" > "$work/disk.img"
# MBR partition entry 2: type byte at 466, start LBA at 470, sector count at 474.
ptype="$(dd if="$work/disk.img" bs=1 skip=466 count=1 2>/dev/null | od -An -tu1 | tr -d '[:space:]')"
[[ "$ptype" == "131" ]] || { echo "error: MBR entry 2 is not a Linux (0x83) partition (type byte $ptype)" >&2; exit 1; }
lba="$(dd if="$work/disk.img" bs=1 skip=470 count=4 2>/dev/null | od -An -tu4 | tr -d '[:space:]')"
sectors="$(dd if="$work/disk.img" bs=1 skip=474 count=4 2>/dev/null | od -An -tu4 | tr -d '[:space:]')"
[[ -n "$lba" && -n "$sectors" ]] || { echo "error: could not read the root partition table" >&2; exit 1; }
dd if="$work/disk.img" of="$work/root.img" bs=512 skip="$lba" count="$sectors" 2>/dev/null

# Stage the key next to the extracted filesystem; debugfs uses relative paths
# in its whitespace-splitting request parser.
cp "$key" "$work/hostkey"
nix shell --inputs-from . nixpkgs#e2fsprogs -c bash "$script_dir/inject-pi-host-key.sh" "$work"
dd if="$work/root.img" of="$work/disk.img" bs=512 seek="$lba" conv=notrunc 2>/dev/null

image_dir="$repo_root/local/images"
mkdir -p "$image_dir"
chmod 700 "$image_dir"
injected="$image_dir/${host}.img.zst"
# Compress into a private staging directory, then atomically replace any
# previous image. This keeps partial output private and makes rebuilds repeatable.
output_tmp="$(mktemp -d "$image_dir/.sd-image.XXXXXXXX")"
staged="$output_tmp/${host}.img.zst"
nix run --inputs-from . nixpkgs#zstd -- -T0 --rm "$work/disk.img" -o "$staged"
chmod 600 "$staged"
mv -f "$staged" "$injected"
echo "$injected"
