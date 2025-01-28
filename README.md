# Nix-based dotfiles

## [![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

[![CI](https://github.com/DavSanchez/nix-dotfiles/actions/workflows/builds.yml/badge.svg)](https://github.com/DavSanchez/nix-dotfiles/actions/workflows/builds.yml) [![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

## Usage

- Run `sudo nixos-rebuild switch --flake .#hostname` to apply your system configuration.
  - If you're still on a live installation medium, run `nixos-install --flake .#hostname` instead, and reboot.
- Run `darwin-rebuild switch --flake .#username@hostname` to apply your macOS configuration.
  - If you don't have nix-darwin installed, try `nix run nix-darwin/master#darwin-rebuild -- switch` first or see [here](https://github.com/LnL7/nix-darwin) for installation.
- Run `home-manager switch --flake .#username@hostname` to apply your home configuration.
  - If you don't have home-manager installed, try `nix run home-manager/master -- init --switch` first.

And that's it, really!

## Influences

- [`github:misterio77/nix-starter-configs`](https://github.com/Misterio77/nix-starter-configs)
- [`github:sherubthakur/dotfiles`](https://github.com/sherubthakur/dotfiles)
- [`github:hlissner/dotfiles`](https://github.com/hlissner/dotfiles)
- [`github:dustinlyons/nixos-config`](https://github.com/dustinlyons/nixos-config)
- [`github:tars0x9752/home`](https://github.com/tars0x9752/home)
- [`github:Misterio77/nix-config`](https://github.com/Misterio77/nix-config)

## Further reading

- [Getting started with Nix Flakes and devshell](https://yuanwang.ca/posts/getting-started-with-flakes.html)

## Issues that might happen

### VSCode and derivatives (VSCodium) won't update

Usually accompanied by the message "An update is ready to install. Visual Studio Code is trying to add a new helper tool".

This is usually caused due to VSCod{e,ium} residing in a different path than `/Applications`. To fix, according to <https://github.com/Microsoft/vscode/issues/7426#issuecomment-277737150>:

```console
sudo chown $USER ~/Library/Caches/com.vscodium.ShipIt/* # or com.microsoft.VSCode.ShipIt/*
xattr -dr com.apple.quarantine ~/Applications/Home\ Manager\ Apps/VSCodium.app # Or Visual\ Studio\ Code.app
```
