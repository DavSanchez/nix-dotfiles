flake := "github:DavSanchez/nix-dotfiles"

_default:
    @just --list
    
update-sops:
    sops updatekeys secrets/secrets.yaml

# Restart the linux-builder VM and wait for its SSH port to accept connections again
# `launchctl kickstart` fails (exit 113) if the service is already down, so tear
# down the daemon first (no-op if not loaded) and re-spin it from its plist.
restart-linux-builder port="31022":
    sudo launchctl bootout system/org.nixos.linux-builder 2>/dev/null || true
    sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.linux-builder.plist
    @echo "linux-builder: restarted, waiting for port {{port}} to accept connections..."
    @for i in $(seq 1 120); do nc -z -w 1 localhost "{{port}}" 2>/dev/null && { echo "linux-builder is up on port {{port}}"; exit 0; }; sleep 1; done; echo "error: linux-builder did not come up on port {{port}} within 120s" >&2; exit 1

# Start the linux-builder VM and wait for its SSH port (no-op when already loaded).
start-linux-builder port="31022":
    @if sudo launchctl print system/org.nixos.linux-builder >/dev/null 2>&1; then \
      echo "linux-builder: already running"; \
    else \
      sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.linux-builder.plist; \
      echo "linux-builder: started, waiting for port {{port}} to accept connections..."; \
    fi
    @for i in $(seq 1 120); do nc -z -w 1 localhost "{{port}}" 2>/dev/null && { echo "linux-builder is up on port {{port}}"; exit 0; }; sleep 1; done; echo "error: linux-builder did not come up on port {{port}} within 120s" >&2; exit 1

# It returns on the next login/reboot with an empty store.
# Stop the linux-builder VM to give its RAM and disk back to the host — e.g. just stop-linux-builder
stop-linux-builder:
    @if sudo launchctl print system/org.nixos.linux-builder >/dev/null 2>&1; then \
      sudo launchctl bootout system/org.nixos.linux-builder && echo "linux-builder: stopped (RAM/disk released; Linux builds fail until 'just start-linux-builder')"; \
    else \
      echo "linux-builder: not running"; \
    fi

# Compare home-manager config.home.path between two branches with dix
dix-home config branch base="master":
    dix \
      $(nix build "{{flake}}/{{base}}#homeConfigurations.\"{{config}}\".activationPackage" --no-link --print-out-paths) \
      $(nix build "{{flake}}/{{branch}}#homeConfigurations.\"{{config}}\".activationPackage" --no-link --print-out-paths)

# Compare home-manager config.home.path between two branches with nix-diff
diff-home config branch base="master":
    nix-diff \
      $(nix build "{{flake}}/{{base}}#homeConfigurations.\"{{config}}\".activationPackage" --no-link --print-out-paths) \
      $(nix build "{{flake}}/{{branch}}#homeConfigurations.\"{{config}}\".activationPackage" --no-link --print-out-paths)

# Compare nix-darwin toplevel between two branches with dix
dix-darwin config branch base="master":
    dix \
      $(nix build "{{flake}}/{{base}}#darwinConfigurations.\"{{config}}\".config.system.build.toplevel" --no-link --print-out-paths) \
      $(nix build "{{flake}}/{{branch}}#darwinConfigurations.\"{{config}}\".config.system.build.toplevel" --no-link --print-out-paths)

# Compare nix-darwin toplevel between two branches with nix-diff
diff-darwin config branch base="master":
    nix-diff \
      $(nix build "{{flake}}/{{base}}#darwinConfigurations.\"{{config}}\".config.system.build.toplevel" --no-link --print-out-paths) \
      $(nix build "{{flake}}/{{branch}}#darwinConfigurations.\"{{config}}\".config.system.build.toplevel" --no-link --print-out-paths)

# Compare NixOS toplevel between two branches with dix
dix-nixos config branch base="master":
    dix \
      $(nix build "{{flake}}/{{base}}#nixosConfigurations.\"{{config}}\".config.system.build.toplevel" --no-link --print-out-paths) \
      $(nix build "{{flake}}/{{branch}}#nixosConfigurations.\"{{config}}\".config.system.build.toplevel" --no-link --print-out-paths)

# Compare NixOS toplevel between two branches with nix-diff
diff-nixos config branch base="master":
    nix-diff \
      $(nix build "{{flake}}/{{base}}#nixosConfigurations.\"{{config}}\".config.system.build.toplevel" --no-link --print-out-paths) \
      $(nix build "{{flake}}/{{branch}}#nixosConfigurations.\"{{config}}\".config.system.build.toplevel" --no-link --print-out-paths)

# Search the exact nixpkgs revision pinned by this flake — e.g. just search-nixpkgs firefox
search-nixpkgs term:
    nix search "github:nixos/nixpkgs/$(nix flake metadata --json | jq -r '.locks.nodes.nixpkgs.locked.rev')" '{{term}}'

# Build any flake attribute verbatim (escape hatch) — e.g. just build-attr nixosConfigurations.mora.pkgs.hermes-agent
build-attr attr:
    nix build '.#{{attr}}' --no-link --print-out-paths

# Build a package from a NixOS config's pkgs — e.g. just build-nixos-pkg mora hermes-agent
build-nixos-pkg config attr:
    just build-attr nixosConfigurations.{{config}}.pkgs.{{attr}}

# Build a package from a nix-darwin config's pkgs — e.g. just build-darwin-pkg sierpe some-package
build-darwin-pkg config attr:
    just build-attr darwinConfigurations.{{config}}.pkgs.{{attr}}

# Build a package from a home-manager config's pkgs — e.g. just build-home-pkg "david@sierpe" zed-editor
build-home-pkg config attr:
    just build-attr 'homeConfigurations."{{config}}".pkgs.{{attr}}'

# Build a package from any config (auto-detects nixos / darwin / home-manager) — e.g. just build-pkg mora hermes-agent
build-pkg config attr:
    @if nix eval --json ".#nixosConfigurations" --apply 'c: builtins.hasAttr "{{config}}" c' 2>/dev/null | grep -q true; then \
      just build-nixos-pkg {{config}} {{attr}}; \
    elif nix eval --json ".#darwinConfigurations" --apply 'c: builtins.hasAttr "{{config}}" c' 2>/dev/null | grep -q true; then \
      just build-darwin-pkg {{config}} {{attr}}; \
    else \
      just build-home-pkg {{config}} {{attr}}; \
    fi

# Same as build-pkg but only prints the build plan (no actual build) — e.g. just build-pkg-dry mora hermes-agent
build-pkg-dry config attr:
    @if nix eval --json ".#nixosConfigurations" --apply 'c: builtins.hasAttr "{{config}}" c' 2>/dev/null | grep -q true; then \
      nix build --dry-run ".#nixosConfigurations.{{config}}.pkgs.{{attr}}"; \
    elif nix eval --json ".#darwinConfigurations" --apply 'c: builtins.hasAttr "{{config}}" c' 2>/dev/null | grep -q true; then \
      nix build --dry-run ".#darwinConfigurations.{{config}}.pkgs.{{attr}}"; \
    else \
      nix build --dry-run ".#homeConfigurations.\"{{config}}\".pkgs.{{attr}}"; \
    fi

# Evaluate (don't build) a sub-attribute as JSON — e.g. just eval-config "david@sierpe" config.programs.zed-editor.userSettings
eval-config config subpath:
    @if nix eval --json ".#nixosConfigurations" --apply 'c: builtins.hasAttr "{{config}}" c' 2>/dev/null | grep -q true; then \
      nix eval --json ".#nixosConfigurations.{{config}}.{{subpath}}"; \
    elif nix eval --json ".#darwinConfigurations" --apply 'c: builtins.hasAttr "{{config}}" c' 2>/dev/null | grep -q true; then \
      nix eval --json ".#darwinConfigurations.{{config}}.{{subpath}}"; \
    else \
      nix eval --json ".#homeConfigurations.\"{{config}}\".{{subpath}}"; \
    fi

# A custom SD image that already boots straight into that host's real config (see
# lib/nixos-sd-image.nix) — no root/nixos bootstrap deploy needed on first flash.
# Build a Raspberry Pi host's SD-card image — e.g. just sd-image mora
sd-image host:
    @nix build --no-link --print-out-paths ".#packages.aarch64-linux.{{host}}-sd-image"

# Write an SD-card image (from `just sd-image`) onto a raw disk. macOS-only; ERASES the disk.
# Flash an image to an SD card — e.g. just flash-image ~/Downloads/nixos-image-*.aarch64-linux.img.zst disk4
flash-image image device:
    #!/usr/bin/env bash
    set -euo pipefail

    if [[ "$(uname -s)" != Darwin ]]; then
      echo "error: flash-image is macOS-only — it uses diskutil to identify/unmount the card and /dev/rdiskN to write it" >&2
      echo "       on Linux: 'lsblk' to find the card, then: zstd -dc <image> | sudo dd of=/dev/sdX bs=4m status=progress && sync" >&2
      exit 1
    fi

    image="{{image}}"; image="${image/#\~/$HOME}"
    device="{{device}}"
    [[ -f "$image" ]] || { echo "error: $image is not a file" >&2; exit 1; }
    num="${device#/dev/}"; num="${num#rdisk}"; num="${num#disk}"
    [[ "$num" =~ ^[0-9]+$ ]] || { echo "error: '$device' is not a disk number, diskN or rdiskN" >&2; exit 1; }
    disk="/dev/disk${num}"
    rdisk="/dev/rdisk${num}"
    [[ -b "$disk" || -c "$disk" ]] || { echo "error: $disk is not a disk device" >&2; exit 1; }

    diskutil info "$disk" | grep -E 'Device / Media Name|Volume Name|Disk Size|Removable Media|Whole|Device Location' || true
    if ! diskutil info "$disk" | grep -qE 'Removable Media: (Removable|Yes)|Ejectable Media: (Yes|Ejectable)|Virtual: Yes|Device Location: External'; then
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
        zstd -dc "$image" | sudo dd of="$rdisk" bs=4m
      else
        nix run --inputs-from . nixpkgs#zstd -- -dc "$image" | sudo dd of="$rdisk" bs=4m
      fi
    else
      sudo dd if="$image" of="$rdisk" bs=4m
    fi
    sync
    diskutil eject "$disk"
    echo "done: $disk"
