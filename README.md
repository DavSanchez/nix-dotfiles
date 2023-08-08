# Nix-based dotfiles

## [![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

> **Hey,** you. You're finally awake. You were trying to configure your OS
> declaratively, right? Walked right into that NixOS ambush, same as us, and those
> dotfiles over there.

These are my current Nix-based `dotfiles` configurations (and shamelessly ripping off several other `dotfiles` repos).

> **Disclaimer:** This is a
> private configuration and an ongoing experiment to feel out NixOS. I make no
> guarantees that it will work out of the box for anyone but myself. It may also
> change drastically and without warning.
>
> Until I can bend spoons with my nix-fu, please don't treat me like an
> authority or expert in the NixOS space. Seek help on [the NixOS
> discourse](https://discourse.nixos.org) instead.

## Usage

- Run `sudo nixos-rebuild switch --flake .#hostname` to apply your system configuration.
  - If you're still on a live installation medium, run `nixos-install --flake .#hostname` instead, and reboot.
- Run `darwin-rebuild switch --flake .#username@hostname` to apply your home configuration.
  - If you don't have nix-darwin installed, try `nix build .#darwinConfigurations.hostname.system` or see [here](https://github.com/LnL7/nix-darwin) for installation.
- Run `home-manager switch --flake .#username@hostname` to apply your home configuration.
  - If you don't have home-manager installed, try `nix shell nixpkgs#home-manager`.
  - When using for the first time, if the above does not work, try activating it directly:

    ```console
    nix build --no-link .#homeConfigurations.username@hostname.activationPackage
    "$(nix path-info .#homeConfigurations.username@hostname.activationPackage)"/activate
    ```

And that's it, really! You're ready to have fun with your configurations using the latest and greatest nix3 flake-enabled command UX.

## Influences

- [`github:misterio77/nix-starter-configs`](https://github.com/Misterio77/nix-starter-configs)
- [`github:sherubthakur/dotfiles`](https://github.com/sherubthakur/dotfiles)
- [`github:hlissner/dotfiles`](https://github.com/hlissner/dotfiles)
- [`github:dustinlyons/nixos-config`](https://github.com/dustinlyons/nixos-config)
- [`github:tars0x9752/home`](https://github.com/tars0x9752/home)
- [`github:Misterio77/nix-config`](https://github.com/Misterio77/nix-config)
- [`github:nix-community/todomvc-nix`](https://github.com/nix-community/todomvc-nix)

## Further reading

- [Getting started with Nix Flakes and devshell](https://yuanwang.ca/posts/getting-started-with-flakes.html)

## Issues

### On `darwin`: cannot link '/nix/store/.tmp-link-XX-XXXX' to '/nix/store/.links/XXXXX': File exists

This is a bug being tracked in https://github.com/NixOS/nix/issues/7273. It appears when you have `nix.settings.auto-optimise-store = true` in your `darwinSystem` (or the equivalent option in `/etc/nix/nix.conf`). Disable it to get rid of this behavior.

If you don't want to disable this option, you can always retry the builds until they succeed (and possibly also performing garbage collection in between). Use `until <switch_command>; do sleep 1; done` and go get a coffee.

### VSCodium won't update

Usually accompanied by the message "An update is ready to install. Visual Studio Code is trying to add a new helper tool".

This is usually caused due to VSCod{e,ium} residing in a different path than `/Applications`. To fix, according to <https://github.com/Microsoft/vscode/issues/7426#issuecomment-277737150>:

```console
sudo chown $USER ~/Library/Caches/com.vscodium.ShipIt/* # or com.microsoft.VSCode.ShipIt/*
xattr -dr com.apple.quarantine ~/Applications/Home\ Manager\ Apps/VSCodium.app # Or Visual\ Studio\ Code.app
```
