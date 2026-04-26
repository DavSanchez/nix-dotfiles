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
