# Home

Home Manager configurations. Each host has an entry point `.nix` file at the
top level of this directory.

## Configurations

| File | User | Host |
| ---- | ---- | ---- |
| `sierpe.nix` | david | sierpe |
| `solio.nix` | david | solio |
| `home-nr.nix` | davidsanchez | nr |

## Modules

`modules/` contains reusable Home Manager modules shared across configurations.
They are internal to this flake and not intended as reusable modules for other
flakes (those live in `../modules/`).
