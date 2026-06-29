flake := "github:DavSanchez/nix-dotfiles"

_default:
    @just --list
    
update-sops:
    sops updatekeys secrets/secrets.yaml

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
