# AGENTS.md

Nix flake managing NixOS, nix-darwin, and Home Manager configs (repo `DavSanchez/nix-dotfiles`, default branch `master`).

## Layout

- `hosts/nixos/<host>.nix` / `hosts/darwin/<host>.nix` — machine entrypoints. `eter` is x86_64-linux; all darwin hosts are aarch64-darwin. `eter` also has a per-host dir `hosts/nixos/eter/` (`fs_share.nix`, `media.nix`, `monitoring.nix`, `zfs.nix`, …) imported alongside shared `hosts/nixos/modules/`.
- Raspberry Pi hosts (`mora` = Pi 5, `bruma` = Pi 3B) are aarch64-linux: a `nixos-hardware` board profile (`inputs.hardware.nixosModules.raspberry-pi-5` / `raspberry-pi-3`) supplies the downstream kernel + `config.txt`, and `hosts/nixos/modules/raspberry-pi.nix` matches the layout of the **official** aarch64 SD image the cards are flashed with (`by-label/NIXOS_SD` root, `by-label/FIRMWARE` FAT). `mora` also has a per-host dir `hosts/nixos/mora/` (`services.nix`, `livedns.nix`).
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
- Raspberry Pi SD cards: use Hydra's `nixos.sd_image.aarch64-linux` (unstable — the 26.05 image lacks the Pi 5 boot files) or build the same installer image from this flake's pinned nixpkgs with `just sd-image` (prints the store path); `just flash-image <image> <disk>` writes it, **macOS-only** (refuses non-removable disks and asks for confirmation — writing erases the card), or on Linux `zstd -dc <image> | sudo dd of=/dev/sdX bs=4m status=progress`. A headless card needs one console session (HDMI or the Pi 5 debug UART) to seed a key or password.
- Apply configs:
  - NixOS: `sudo nixos-rebuild switch --flake .#eter`
  - nix-darwin: `darwin-rebuild switch --flake .#sierpe` (or `.#V9X576T260` for nr)
  - Home Manager: `nix run home-manager/master -- switch --flake .#david@sierpe`
- Deploy the `deploy-rs` nodes in `flake.nix` with `deploy .#<host>`: `eter` (`eter.local`), `mora` (`mora.local`), `bruma` (`bruma.local`). A freshly flashed Pi boots the official image, whose user is `root`/`nixos` rather than `david`, so the first rollout is `deploy --ssh-user root --hostname <ip> .#<host>`; afterwards the node behaves as usual (our config ships `david` with the repo's keys and passwordless sudo).
- Linux builder VM: always up with its daemon, and its memory is a ceiling the host never gets back — `just stop-linux-builder` releases it (RAM + disk), `just start-linux-builder` brings it back, `just restart-linux-builder` re-spins it after a `nix.linux-builder.*` change.

## Gotchas

- **Raspberry Pi kernels build from source**: `nixos-hardware`'s `linux-rpi` is not in `cache.nixos.org`, nor is anything built against it, so the first CI run (native aarch64 runner) or Mac build (through the `linux-builder` VM) compiles it; later builds hit the local store or the `davsanchez` cachix cache.
- **One ssh host key per Pi**: `sops` decrypts with the host key generated on first boot (`age.sshKeyPaths = /etc/ssh/ssh_host_ed25519_key`), so a freshly flashed card no longer matches its recipient in `.sops.yaml` — add the new key and `just update-sops`, or that host's secrets (Wi-Fi PSK, Gandi PAT) fail to decrypt. `bruma` has no sops secrets yet.
- **The firmware module owns the FAT partition**: each switch rewrites `config.txt`, copies device trees/overlays and prunes stale entries — don't hand-edit files there. Its copy is ~26 MB of the stock 30 MB partition; if a switch fails with `No space left on device`, drop `firmware.enable` or enlarge the partition.
- **Secrets**: `secrets/secrets.yaml` is age-encrypted (sops). Decryption needs the key at `~/.config/sops/age/keys.txt`; after adding keys, re-encrypt with `just update-sops`. `git diff` shows decrypted content via the `diff=sopsdiffer` textconv (`sops decrypt`). Never commit or echo decrypted values.
- macOS builds x86_64-linux derivations via a `nix.linux-builder` (darwin-builder VM). CI activates the throwaway `linux-builder-bootstrap` darwin config first; the real darwin hosts configure their own builder.
- The darwin `networking.enableHosts` module writes `/etc/hosts` as a regular file during activation (macOS Network framework can't resolve symlinks there); upstreaming intent is documented in `tests/darwin/UPSTREAMING.md`.
- Dependency bumps and lockfile maintenance are automated by Renovate (automerge, conventional-commit PRs like `chore(deps): lock file maintenance`) — don't hand-bump inputs.
- Commit style is Conventional Commits (`chore:`, `fix(nix):`, `pkg: update X`).
- CI gates each workflow on a per-workflow path PATTERN (in `.github/workflows/*.yml`); `flake-check` runs on any `.nix` or `flake.lock` change.