# Upstreaming to nix-darwin

## Context

nix-darwin does not currently provide declarative `/etc/hosts` management. PR [#939](https://github.com/nix-darwin/nix-darwin/pull/939) attempted to add `networking.hosts` and `networking.hostFiles` from NixOS but was [reverted](https://github.com/nix-darwin/nix-darwin/pull/1353) within 24 hours because macOS Network framework does not follow symlinks for `/etc/hosts`, breaking DNS resolution entirely.

[Issue #1035](https://github.com/nix-darwin/nix-darwin/issues/1035) remains open requesting this feature. The upstream PR is [#1831](https://github.com/nix-darwin/nix-darwin/pull/1831); `modules/darwin/networking.nix` and the `networking-hosts*` tests here are kept in sync with it (same logic, with `lib.` spelled out instead of `with lib;`), so they can be dropped once it lands.

## Key Design Difference from NixOS

NixOS generates `/etc/hosts` via `environment.etc.hosts.source`, which creates a **symlink** to a store path. This does not work on macOS — the Network framework and `dscacheutil` do not resolve symlinks for `/etc/hosts`, causing `ssh localhost` and all DNS queries to fail.

This implementation uses an **activation script** (`system.activationScripts.postActivation`) that writes a **regular file** to `/etc/hosts`, avoiding the symlink problem entirely.

## Files to Contribute

### New module: `modules/networking/hosts.nix`

Contains:
- `networking.enableHosts` (`bool`, default `false`) — opt-in toggle to manage `/etc/hosts`
- `networking.hosts` (`attrsOf (listOf str)`) — IP-to-hostnames map
- `networking.extraHosts` (`lines`) — verbatim text entries
- `networking.hostFiles` (`listOf path`) — files to concatenate
- Activation script that merges the original macOS `/etc/hosts` content with generated entries and writes a regular file to `/etc/hosts`; with `enableHosts = false` it only strips a stale Nix block
- Assertions rejecting `localhost` mapped to non-loopback addresses and `enableHosts` combined with `environment.etc."hosts"`, and a warning when the other options are set but `enableHosts` is `false`

### New module: `modules/config/stevenblack.nix`

Mirrors [NixOS's `nixos/modules/config/stevenblack.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/stevenblack.nix) verbatim:
- `networking.stevenblack.enable`
- `networking.stevenblack.package`
- `networking.stevenblack.block`
- `networking.stevenblack.whitelist`
- Appends filtered blocklist files to `networking.hostFiles`

### Tests

Drop the `networking-hosts*` tests into `tests/` and register them in `release.nix`:

```nix
tests.networking-hosts = makeTest ./tests/networking-hosts.nix;
tests.networking-hosts-cleanup = makeTest ./tests/networking-hosts-cleanup.nix;
# ... one line per file
tests.networking-stevenblack = makeTest ./tests/networking-stevenblack.nix;
```

They run the generated activation fragment against a scratch `/etc/hosts` (the path is substituted), so they exercise behaviour rather than grep the script. They cover stale, multiple and unterminated blocks, idempotency, a disabled or empty configuration, a missing or symlinked `/etc/hosts`, preserved mode/ACLs/xattrs, and temporary files after failure, interruption and a killed run.

## How the /etc/hosts Merge Works

```
Activation order (from modules/system/activation-scripts.nix):
  ...
  etc           ← creates symlinks in /etc/static, cleans stale links
  ...
  networking    ← restores /etc/hosts.before-nix-darwin backup if it exists
  ...
  postActivation ← our script runs here
```

The `postActivation` script rebuilds `/etc/hosts` only when its content changes:
1. Computes the wanted file: the current `/etc/hosts` without any `# BEGIN Nix-managed` ... `# END Nix-managed` block (idempotency), followed by a fresh block if `enableHosts` is on and there is anything to add. A `BEGIN` without `END` is kept as user content, and a later `BEGIN` ends it, so it can't swallow the lines after it.
2. Returns, silently, if that equals the current file, or if there is nothing to manage and no file (a missing `/etc/hosts` is never created).
3. Otherwise writes it to `/etc/hosts.nix.<pid>.XXXXXX`, a copy of the old file made with `/bin/cp -p` (owner, mode, ACLs, xattrs such as `com.apple.provenance` survive), and renames it into place. A symlink (e.g. from `environment.etc."hosts"` or #939) is replaced by a regular file; with `enableHosts = false` it is left alone.

The temporary file is removed by an exit trap when activation fails or is interrupted. Leftovers of killed runs are swept by the next one, but only when their PID is gone, because nothing serializes concurrent activations.

## Opting-in

`networking.enableHosts` (default `false`) provides an explicit opt-in mechanism. Users who don't want nix-darwin to manage `/etc/hosts` at all (e.g., Docker Desktop modifies it) simply leave it unset.

When a dependent feature like `networking.stevenblack` is enabled, it forces `enableHosts = true` automatically — users don't need to set both.

## Known Limitations for Upstream PR

1. **Duplicate localhost entries**: The stock macOS `/etc/hosts` already contains `127.0.0.1 localhost` and `::1 localhost`. The generated Nix content also includes them. Harmless (first match wins) but visually redundant. Could be addressed by detecting existing entries at build time or omitting them from the generated content when merging.

2. **Activation script ordering**: We rely on `postActivation` running after `networking`. This is guaranteed by the hardcoded order in `activation-scripts.nix`, but there's no declarative dependency mechanism for activation scripts in nix-darwin.

3. **Concurrent activations**: nothing serializes `activate`. Temporary files are PID-scoped so runs don't delete each other's, and the final rename is atomic, but two runs with different configurations would both write `/etc/hosts` and the last one wins. A real lock would be a separate change.
