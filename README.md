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

# TODO cleanup and order

Uninstallation:

1. nix-darwin
2. home-manager
3. nix

If after uninstalling nix-darwin you run into issues... try this (from https://discourse.nixos.org/t/ssl-ca-cert-error-on-macos/31171/5) 

```sh
sudo rm /etc/ssl/certs/ca-certificates.crt
sudo ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```

## Installation again

0. Chances are my binary cache has already compiled much of the store paths. If you have `cachix` installed, run `cachix use davsanchez` to use it. You can run this step after installing Nix, after installing nix-darwin, or at any moment to benefit from the caching.
  a. Particularly useful for saving compilation time for the customized Iosevka fonts that I am using... why the hell do they take so long? 8 hours!?!?!?!??
1. Install Nix using the Determinate Nix installer, select **no** on the first prompt, which is to install the enterprise-focused Determinate Nix downstream version.
2. Install nix-darwin via switching to one of the existing configs directly with `nix run nix-darwin/master#darwin-rebuild -- switch --flake .#<hostname>`.
  a. If you do not have an existing config that is applicable, follow these instructions: TODO
3. Install home-manager via switching to one of the existing configs directly with `nix run home-manager/master -- switch --flake .#<USER>@<HOSTNAME>`.
  a. If you do not have an existing config that is applicable, follow these instructions: TODO
4. Enjoy!
