_default:
    @just --list

update-sops:
    sops updatekeys secrets/secrets.yaml

# Restart the linux-builder VM and wait for its SSH port to accept connections again
restart-linux-builder port="31022":
    @bash "$PWD/scripts/linux-builder.sh" restart {{quote(port)}}

# Start the linux-builder VM and wait for its SSH port (no-op when already loaded).
start-linux-builder port="31022":
    @bash "$PWD/scripts/linux-builder.sh" start {{quote(port)}}

# Stop the linux-builder VM to give its RAM and disk back to the host.
# It returns on the next login/reboot with an empty store.
stop-linux-builder:
    @bash "$PWD/scripts/linux-builder.sh" stop

# Compare home-manager config.home.path between two branches with dix
dix-home config branch base="master":
    @bash "$PWD/scripts/config-diff.sh" dix {{quote(config)}} {{quote(branch)}} {{quote(base)}}

# Compare home-manager config.home.path between two branches with nix-diff
diff-home config branch base="master":
    @bash "$PWD/scripts/config-diff.sh" nix-diff {{quote(config)}} {{quote(branch)}} {{quote(base)}}

# Compare nix-darwin toplevel between two branches with dix
dix-darwin config branch base="master":
    @bash "$PWD/scripts/config-diff.sh" dix {{quote(config)}} {{quote(branch)}} {{quote(base)}}

# Compare nix-darwin toplevel between two branches with nix-diff
diff-darwin config branch base="master":
    @bash "$PWD/scripts/config-diff.sh" nix-diff {{quote(config)}} {{quote(branch)}} {{quote(base)}}

# Compare NixOS toplevel between two branches with dix
dix-nixos config branch base="master":
    @bash "$PWD/scripts/config-diff.sh" dix {{quote(config)}} {{quote(branch)}} {{quote(base)}}

# Compare NixOS toplevel between two branches with nix-diff
diff-nixos config branch base="master":
    @bash "$PWD/scripts/config-diff.sh" nix-diff {{quote(config)}} {{quote(branch)}} {{quote(base)}}

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
    @bash "$PWD/scripts/build-pkg.sh" {{quote(config)}} {{quote(attr)}}

# Same as build-pkg but only prints the build plan (no actual build) — e.g. just build-pkg-dry mora hermes-agent
build-pkg-dry config attr:
    @bash "$PWD/scripts/build-pkg.sh" --dry-run {{quote(config)}} {{quote(attr)}}

# Evaluate (don't build) a sub-attribute as JSON — e.g. just eval-config "david@sierpe" config.programs.zed-editor.userSettings
eval-config config subpath:
    @bash "$PWD/scripts/eval-config.sh" {{quote(config)}} {{quote(subpath)}}

# Create a per-host ed25519 host key under the git-ignored local/host-keys/ dir.
# It becomes the host's SSH identity and, via `sops.age.sshKeyPaths`, its age identity:
# register its public half in .sops.yaml (`just update-sops`) before `just sd-image`,
# and the flashed card can decrypt secrets from the first boot.
# Create or reuse a Raspberry Pi host key — e.g. just host-key mora
host-key host:
    @bash "$PWD/scripts/host-key.sh" {{quote(host)}}

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
