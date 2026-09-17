# AGENTS.md

Nix flake managing NixOS, nix-darwin, and Home Manager configs (repo `DavSanchez/nix-dotfiles`, default branch `master`).

## Layout

- `hosts/nixos/<host>.nix` / `hosts/darwin/<host>.nix` — machine entrypoints. `eter` is x86_64-linux; all darwin hosts are aarch64-darwin. `eter` also has a per-host dir `hosts/nixos/eter/` (`fs_share.nix`, `media.nix`, `monitoring.nix`, `zfs.nix`, …) imported alongside shared `hosts/nixos/modules/`.
- Raspberry Pi hosts (`mora` = Pi 5, `bruma` = Pi 3B) are aarch64-linux and split across two layers: a `nixos-hardware` board profile (`inputs.hardware.nixosModules.raspberry-pi-5` / `raspberry-pi-3`) for the downstream kernel + `config.txt`, and `hosts/nixos/modules/raspberry-pi-sd-image.nix` for the generic aarch64 SD-card image, U-Boot and firmware-partition handling. Same config is the SD-image source *and* the `deploy-rs` target. `mora` also has a per-host dir `hosts/nixos/mora/` (`services.nix`, `livedns.nix`).
- `home/darwin/*.nix` — Home Manager entrypoints (`sierpe`, `solio`, `home-nr.nix`). All are aarch64-darwin only.
- `home/modules/` — per-user Home Manager modules (internal to this machine set). `modules/{nixos,darwin}/` — reusable modules exported from the flake (`self.nixosModules`, `self.darwinModules`); `self.darwinModules.networking` and `self.darwinModules.stevenblack` are custom and power the `/etc/hosts` tests.
- `pkgs/` — custom packages (`kontroll`, `omniwm`); `overlays/`; `tests/darwin/` + `lib/darwin-tests.nix` — module test harness.
- The `nr` machine is keyed by Apple serial: darwin config name is `V9X576T260`, home config is `davidsanchez@V9X576T260` (host file is `hosts/darwin/nr.nix`).

## Commands

- Format all Nix: `nix fmt` (formatter is `nixfmt-tree`).
- Check the flake: `nix flake check -L --keep-going`. Only run this on Linux; darwin configs don't evaluate on Linux. On macOS, build darwin checks individually (see tests) — CI also skips the `deploy-activate`/`deploy-schema` checks there.
- Darwin module tests: `nix build .#checks.aarch64-darwin.<test>`. Every `.nix` file in `tests/darwin/` becomes a check automatically.
- Build a package inside a config's `pkgs`: `just build-pkg <host> <pkg>` (auto-detects nixos/darwin/home); `just build-pkg-dry` for dry-run. Raw escape hatch: `just build-attr <attr>`.
- Eval any config sub-attr as JSON: `just eval-config <host|user@host> <attr-path>` (needed for quoted names like `david@sierpe`).
- Raspberry Pi SD cards: `just sd-image <host>` builds the image (prints the store path, image lives in `<out>/sd-image/*.img.zst`); `just flash-sd <host> <disk>` decompresses and `dd`s it to `/dev/rdisk<N>` after printing `diskutil info` and asking for confirmation. Writing erases the card.
- Apply configs:
  - NixOS: `sudo nixos-rebuild switch --flake .#eter`
  - nix-darwin: `darwin-rebuild switch --flake .#sierpe` (or `.#V9X576T260` for nr)
  - Home Manager: `nix run home-manager/master -- switch --flake .#david@sierpe`
- Deploy the `deploy-rs` nodes in `flake.nix` with `deploy .#<host>`: `eter` (`eter.local`), `mora` (`mora.local`), `bruma` (`bruma.local`). The Pi nodes ship the same `authorized_keys` + passwordless-sudo setup as the image, so they are deployable from the first boot.

## Gotchas

- **Raspberry Pi kernels are built from source**: `nixos-hardware`'s `linux-rpi` (6.18.x, Raspberry Pi downstream tree) is not in `cache.nixos.org`, and neither is any custom package built against it. The first `just sd-image`/CI run compiles it (the aarch64 runner does this natively; on a Mac it goes through the `linux-builder` VM, which needs RAM/disk budget). Subsequent builds hit the local store or the `davsanchez` cachix cache.
- **One ssh host key per Pi**: `sops` decrypts with `age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]` (the host key generated on first boot). A freshly flashed card has a *new* host key, so the old recipient in `.sops.yaml` no longer matches — add the new one and `just update-sops`, otherwise every secret on that host (Wi-Fi PSK, Gandi PAT, Radicle keys) fails to decrypt. `bruma` has no sops secrets yet.
- **The firmware module owns the FAT partition** (`hardware.raspberry-pi.firmware.enable`): each switch rewrites `config.txt`, copies device trees/overlays and prunes stale `*.dtb` and unrecognised `overlays/` entries. Don't hand-edit files there.
- **Secrets**: `secrets/secrets.yaml` is age-encrypted (sops). Decryption needs the key at `~/.config/sops/age/keys.txt`; after adding keys, re-encrypt with `just update-sops`. `git diff` shows decrypted content via the `diff=sopsdiffer` textconv (`sops decrypt`). Never commit or echo decrypted values.
- macOS builds x86_64-linux derivations via a `nix.linux-builder` (darwin-builder VM). CI activates the throwaway `linux-builder-bootstrap` darwin config first; the real darwin hosts configure their own builder.
- The darwin `networking.enableHosts` module writes `/etc/hosts` as a regular file during activation (macOS Network framework can't resolve symlinks there); upstreaming intent is documented in `tests/darwin/UPSTREAMING.md`.
- Dependency bumps and lockfile maintenance are automated by Renovate (automerge, conventional-commit PRs like `chore(deps): lock file maintenance`) — don't hand-bump inputs.
- Commit style is Conventional Commits (`chore:`, `fix(nix):`, `pkg: update X`).
- CI gates each workflow on a per-workflow path PATTERN (in `.github/workflows/*.yml`); `flake-check` runs on any `.nix` or `flake.lock` change.