# Hosts

Each directory here is either a machine or a set of shared platform aspects.

## Machines

| Host | Platform | Role |
| ---- | -------- | ---- |
| `blackbee/` | NixOS (aarch64) | Raspberry Pi 5 |
| `eter/` | NixOS (x86_64) | Home server |
| `sierpe/` | nix-darwin (aarch64) | macOS |
| `solio/` | nix-darwin (aarch64) | macOS |

## Platform aspects

`nixos/` and `darwin/` are **not hosts** — they contain shared configuration
modules imported by the machines above. They are internal to this flake and not
intended as reusable modules for other flakes (those live in `../modules/`).

| Directory | Imported by |
| --------- | ----------- |
| `nixos/` | `blackbee`, `eter` |
| `darwin/` | `sierpe`, `solio` |
