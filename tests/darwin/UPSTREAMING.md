# Upstreaming to nix-darwin

## Context

nix-darwin does not currently provide declarative `/etc/hosts` management. PR [#939](https://github.com/nix-darwin/nix-darwin/pull/939) attempted to add `networking.hosts` and `networking.hostFiles` from NixOS but was [reverted](https://github.com/nix-darwin/nix-darwin/pull/1353) within 24 hours because macOS Network framework does not follow symlinks for `/etc/hosts`, breaking DNS resolution entirely.

[Issue #1035](https://github.com/nix-darwin/nix-darwin/issues/1035) remains open requesting this feature.

## Key Design Difference from NixOS

NixOS generates `/etc/hosts` via `environment.etc.hosts.source`, which creates a **symlink** to a store path. This does not work on macOS — the Network framework and `dscacheutil` do not resolve symlinks for `/etc/hosts`, causing `ssh localhost` and all DNS queries to fail.

This implementation uses an **activation script** (`system.activationScripts.postActivation`) that writes a **regular file** to `/etc/hosts`, avoiding the symlink problem entirely.

## Files to Contribute

### New module: `modules/networking/hosts.nix`

Contains:
- `networking.hosts` (`attrsOf (listOf str)`) — IP-to-hostnames map
- `networking.extraHosts` (`lines`) — verbatim text entries
- `networking.hostFiles` (`listOf path`) — files to concatenate
- Activation script that merges the original macOS `/etc/hosts` content with generated entries and writes a regular file to `/etc/hosts`

### New module: `modules/config/stevenblack.nix`

Mirrors [NixOS's `nixos/modules/config/stevenblack.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/stevenblack.nix) verbatim:
- `networking.stevenblack.enable`
- `networking.stevenblack.package`
- `networking.stevenblack.block`
- `networking.stevenblack.whitelist`
- Appends filtered blocklist files to `networking.hostFiles`

### Tests

Drop `tests/darwin/networking-hosts.nix` and `tests/darwin/networking-stevenblack.nix` into `tests/` and register them in `release.nix`:

```nix
tests.networking-hosts = makeTest ./tests/networking-hosts.nix;
tests.networking-stevenblack = makeTest ./tests/networking-stevenblack.nix;
```

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

The `postActivation` script:
1. Reads current `/etc/hosts` (a regular file at this point)
2. Strips any previous `# BEGIN Nix-managed` ... `# END Nix-managed` block (idempotency)
3. Writes: `[original macOS content] + [# BEGIN Nix-managed] + [generated] + [# END Nix-managed]`

## Known Limitations / Discussion Points for Upstream PR

1. **Duplicate localhost entries**: The stock macOS `/etc/hosts` already contains `127.0.0.1 localhost` and `::1 localhost`. The generated Nix content also includes them. Harmless (first match wins) but visually redundant. Could be addressed by detecting existing entries at build time or omitting them from the generated content when merging.

2. **Activation script ordering**: We rely on `postActivation` running after `networking`. This is guaranteed by the hardcoded order in `activation-scripts.nix`, but there's no declarative dependency mechanism for activation scripts in nix-darwin.

3. **Opt-out**: Users who don't want nix-darwin to manage `/etc/hosts` at all (e.g., Docker Desktop modifies it) currently have no way to disable this if `networking.hosts` or similar options are set. Consider adding a `networking.hosts.enable` option.
