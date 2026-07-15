# Hosts

Each host has an entry point `.nix` file at the top level of this directory.
Hosts with complex configurations also have a same-named subdirectory containing
their additional modules.

## Machines

| File | Platform | Role |
| ---- | -------- | ---- |
| `mora.nix` | NixOS (aarch64) | Raspberry Pi 5 |
| `eter.nix` | NixOS (x86_64) | Home server |
| `sierpe.nix` | nix-darwin (aarch64) | macOS |
| `solio.nix` | nix-darwin (aarch64) | macOS |

## Platform modules

`modules/nixos/` and `modules/darwin/` are **not hosts** — they contain shared
configuration imported by the machines above. They are internal to this flake
and not intended as reusable modules for other flakes (those live in
`../modules/`).

| Directory | Imported by |
| --------- | ----------- |
| `modules/nixos/` | `mora`, `eter` |
| `modules/darwin/` | `sierpe`, `solio` |
