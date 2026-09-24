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

# Create a per-host ed25519 host key under the git-ignored local/host-keys/ dir.
# It becomes the host's SSH identity and, via `sops.age.sshKeyPaths`, its age identity:
# register its public half in .sops.yaml (`just update-sops`) before `just sd-image`,
# and the flashed card can decrypt secrets from the first boot.
# Create or reuse a Raspberry Pi host key — e.g. just host-key mora
host-key host:
    #!/usr/bin/env bash
    set -euo pipefail
    # Trace every command with `JUST_TRACE=1 just host-key <host>`.
    if [[ -n "${JUST_TRACE:-}" ]]; then set -x; fi
    dir="$PWD/local/host-keys"
    key="$dir/{{host}}.ed25519"
    mkdir -p "$dir"
    if [[ -e "$key" ]]; then
      echo "reusing existing $key" >&2
    else
      ssh-keygen -t ed25519 -N "" -C "{{host}} host key" -f "$key"
    fi
    recipient="$(nix run --inputs-from . nixpkgs#ssh-to-age -- -i "$key.pub")"
    printf '\nage recipient for %s: %s\n\n' "{{host}}" "$recipient"
    echo "Add it to .sops.yaml (both the top-level 'keys:' list and the"
    echo "'creation_rules' age list), then run: just update-sops"

# A custom SD image that already boots straight into that host's real config (see
# lib/nixos-sd-image.nix) — no root/nixos bootstrap deploy needed on first flash.
# When a key from `just host-key <host>` exists it is injected into a non-store copy
# of the image under local/images/ (so the private key never enters the Nix store);
# the image's sops age identity is already in .sops.yaml, so secrets work from boot.
# Build a Raspberry Pi host's SD-card image — e.g. just sd-image mora
sd-image host:
    @bash "$PWD/scripts/sd-image.sh" {{quote(host)}}

# Write an SD-card image (from `just sd-image`) onto a raw disk. macOS-only; ERASES the disk.
# Flash an image to an SD card — e.g. just flash-image ~/Downloads/nixos-image-*.aarch64-linux.img.zst disk4
flash-image image device:
    @bash "$PWD/scripts/flash-image.sh" {{quote(image)}} {{quote(device)}}
