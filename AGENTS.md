# AGENTS.md

Nix flake managing NixOS, nix-darwin, and Home Manager configs (repo `DavSanchez/nix-dotfiles`, default branch `master`).

## Layout

- `hosts/nixos/<host>.nix` / `hosts/darwin/<host>.nix` — machine entrypoints. `eter` is x86_64-linux; all darwin hosts are aarch64-darwin. `eter` also has a per-host dir `hosts/nixos/eter/` (`fs_share.nix`, `media.nix`, `monitoring.nix`, `zfs.nix`, …) imported alongside shared `hosts/nixos/modules/`.
- Raspberry Pi hosts (`mora` = Pi 5, `bruma` = Pi 3B) are aarch64-linux: a `nixos-hardware` board profile (`inputs.hardware.nixosModules.raspberry-pi-5` / `raspberry-pi-3`) provides the downstream kernel + `config.txt`, and `hosts/nixos/modules/raspberry-pi.nix` matches the layout of the **official** aarch64 SD image the cards are flashed with (`by-label/NIXOS_SD` root, `by-label/FIRMWARE` FAT) and enables the firmware-partition sync. No image is built from this flake. `mora` also has a per-host dir `hosts/nixos/mora/` (`services.nix`, `livedns.nix`).
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
- Raspberry Pi SD cards: flash the **official** aarch64 SD image from Hydra (`nixos.sd_image.aarch64-linux` — needs `nixos-unstable`, since 26.05 images lack the Pi 5 boot files; that job is the *installer* flavour, so `root`/`nixos` have empty passwords and sshd is on). `just flash-image <image> <disk>` writes it, **macOS-only** (`diskutil` + `/dev/rdiskN`, refuses non-removable disks, asks for confirmation — writing erases the card); on Linux use `zstd -dc <image> | sudo dd of=/dev/sdX bs=4m status=progress`. A headless card needs one console session (HDMI or the Pi 5 debug UART) to seed a key or password, then the *first* activation from the Mac overrides the node's user: `deploy --ssh-user root --hostname <ip> .#mora` (avahi only resolves `mora.local` after that switch, and `david` only exists after it).
- Apply configs:
  - NixOS: `sudo nixos-rebuild switch --flake .#eter`
  - nix-darwin: `darwin-rebuild switch --flake .#sierpe` (or `.#V9X576T260` for nr)
  - Home Manager: `nix run home-manager/master -- switch --flake .#david@sierpe`
- Deploy the `deploy-rs` nodes in `flake.nix` with `deploy .#<host>`: `eter` (`eter.local`), `mora` (`mora.local`), `bruma` (`bruma.local`). A freshly flashed Pi runs the official image, so its user is `root`/`nixos`, not `david`: bootstrap once with `deploy --ssh-user root --hostname <ip> .#<host>` (or `sudo nixos-rebuild switch --flake github:DavSanchez/nix-dotfiles#<host>` on the Pi itself, which substitutes from the `davsanchez` cachix cache once CI has built it). After that the node behaves as usual — our config ships `david` with the repo's keys and passwordless sudo.
- Linux builder VM: `just stop-linux-builder` releases the VM's RAM and disk to the host when no Linux builds are needed, `just start-linux-builder` brings it back (no-op when already up), and `just restart-linux-builder` re-spins it after a `nix.linux-builder.*` change — the VM is otherwise always up, and its memory is a ceiling the host never gets back.

## Gotchas

- **Raspberry Pi kernels are built from source**: `nixos-hardware`'s `linux-rpi` (6.18.x, Raspberry Pi downstream tree) is not in `cache.nixos.org`, and neither is any custom package built against it. The first deploy/CI run compiles it (the aarch64 runner does this natively; on a Mac it goes through the `linux-builder` VM, which needs RAM/disk budget). Subsequent builds hit the local store or the `davsanchez` cachix cache.
- **One ssh host key per Pi**: `sops` decrypts with `age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]` (the host key generated on first boot). A freshly flashed card has a *new* host key, so the old recipient in `.sops.yaml` no longer matches — add the new one and `just update-sops`, otherwise every secret on that host (Wi-Fi PSK, Gandi PAT, Radicle keys) fails to decrypt. `bruma` has no sops secrets yet.
- **The firmware module owns the FAT partition** (`hardware.raspberry-pi.firmware.enable`): each switch rewrites `config.txt`, copies device trees/overlays and prunes stale `*.dtb` and unrecognised `overlays/` entries. Don't hand-edit files there. Its copy measures ~26 MB against the stock 30 MB partition (the official image fills ~25 MB), so it fits but without much slack — if a switch ever fails there with `No space left on device`, drop `firmware.enable` (the partition then keeps whatever the flashed image put there) or enlarge the partition.
- **Secrets**: `secrets/secrets.yaml` is age-encrypted (sops). Decryption needs the key at `~/.config/sops/age/keys.txt`; after adding keys, re-encrypt with `just update-sops`. `git diff` shows decrypted content via the `diff=sopsdiffer` textconv (`sops decrypt`). Never commit or echo decrypted values.
- macOS builds x86_64-linux derivations via a `nix.linux-builder` (darwin-builder VM). CI activates the throwaway `linux-builder-bootstrap` darwin config first; the real darwin hosts configure their own builder.
- The darwin `networking.enableHosts` module writes `/etc/hosts` as a regular file during activation (macOS Network framework can't resolve symlinks there); upstreaming intent is documented in `tests/darwin/UPSTREAMING.md`.
- Dependency bumps and lockfile maintenance are automated by Renovate (automerge, conventional-commit PRs like `chore(deps): lock file maintenance`) — don't hand-bump inputs.
- Commit style is Conventional Commits (`chore:`, `fix(nix):`, `pkg: update X`).
- CI gates each workflow on a per-workflow path PATTERN (in `.github/workflows/*.yml`); `flake-check` runs on any `.nix` or `flake.lock` change.