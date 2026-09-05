# AGENTS.md

Nix flake managing NixOS, nix-darwin, and Home Manager configs (repo `DavSanchez/nix-dotfiles`, default branch `master`).

## Layout

- `hosts/nixos/<host>.nix` / `hosts/darwin/<host>.nix` — machine entrypoints. `eter` is x86_64-linux; all darwin hosts are aarch64-darwin. `eter` also has a per-host dir `hosts/nixos/eter/` (`fs_share.nix`, `media.nix`, `monitoring.nix`, `zfs.nix`, …) imported alongside shared `hosts/nixos/modules/`.
- `mora` (Raspberry Pi 5, aarch64) is currently disabled/commented in `flake.nix` — but keep `hosts/nixos/mora.nix` + `hosts/nixos/mora/` up to date; it's maintained even though unbuilt.
- `home/darwin/*.nix` — Home Manager entrypoints (`sierpe`, `solio`, `home-nr.nix`). All are aarch64-darwin only.
- `home/modules/` — per-user Home Manager modules (internal to this machine set). `modules/{nixos,darwin,home}/` — reusable modules exported from the flake (`self.*Modules`); `self.darwinModules.networking` and `self.darwinModules.stevenblack` are custom and power the `/etc/hosts` tests.
- `pkgs/` — custom packages (`kontroll`, `omniwm`); `overlays/`; `tests/darwin/` + `lib/darwin-tests.nix` — module test harness.
- The `nr` machine is keyed by Apple serial: darwin config name is `V9X576T260`, home config is `davidsanchez@V9X576T260` (host file is `hosts/darwin/nr.nix`).

## Commands

- Format all Nix: `nix fmt` (formatter is `nixfmt-tree`).
- Check the flake: `nix flake check -L --keep-going`. Only run this on Linux; darwin configs don't evaluate on Linux. On macOS, build darwin checks individually (see tests) — CI also skips the `deploy-activate`/`deploy-schema` checks there.
- Darwin module tests: `nix build .#checks.aarch64-darwin.<test>`. Every `.nix` file in `tests/darwin/` becomes a check automatically.
- Build a package inside a config's `pkgs`: `just build-pkg <host> <pkg>` (auto-detects nixos/darwin/home); `just build-pkg-dry` for dry-run. Raw escape hatch: `just build-attr <attr>`.
- Eval any config sub-attr as JSON: `just eval-config <host|user@host> <attr-path>` (needed for quoted names like `david@sierpe`).
- Apply configs:
  - NixOS: `sudo nixos-rebuild switch --flake .#eter`
  - nix-darwin: `darwin-rebuild switch --flake .#sierpe` (or `.#V9X576T260` for nr)
  - Home Manager: `nix run home-manager/master -- switch --flake .#david@sierpe`
- Deploy `eter` via the `deploy-rs` `deploy` node (`eter.local`, in `flake.nix`).

## Gotchas

- **Secrets**: `secrets/secrets.yaml` is age-encrypted (sops). Decryption needs the key at `~/.config/sops/age/keys.txt`; after adding keys, re-encrypt with `just update-sops`. `git diff` shows decrypted content via the `diff=sopsdiffer` textconv (`sops decrypt`). Never commit or echo decrypted values.
- macOS builds x86_64-linux derivations via a `nix.linux-builder` (darwin-builder VM). CI activates the throwaway `linux-builder-bootstrap` darwin config first; the real darwin hosts configure their own builder.
- The darwin `networking.enableHosts` module writes `/etc/hosts` as a regular file during activation (macOS Network framework can't resolve symlinks there); upstreaming intent is documented in `tests/darwin/UPSTREAMING.md`.
- Dependency bumps and lockfile maintenance are automated by Renovate (automerge, conventional-commit PRs like `chore(deps): lock file maintenance`) — don't hand-bump inputs.
- Commit style is Conventional Commits (`chore:`, `fix(nix):`, `pkg: update X`).
- CI gates each workflow on a per-workflow path PATTERN (in `.github/workflows/*.yml`); `flake-check` runs on any `.nix` or `flake.lock` change.