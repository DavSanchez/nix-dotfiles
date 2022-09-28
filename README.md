# Nix-based dotfiles

## [![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

> **Hey,** you. You're finally awake. You were trying to configure your OS
> declaratively, right? Walked right into that NixOS ambush, same as us, and those
> dotfiles over there.

I'm trying to replace my current `dotfiles` configuration by basing it in Nix and shamelessly ripping off several other `dotfiles` repos.

> **Disclaimer:** _This is a
> private configuration and an ongoing experiment to feel out NixOS. I make no
> guarantees that it will work out of the box for anyone but myself. It may also
> change drastically and without warning.
>
> Until I can bend spoons with my nix-fu, please don't treat me like an
> authority or expert in the NixOS space. Seek help on [the NixOS
> discourse](https://discourse.nixos.org) instead.

## Influences

- [`github:sherubthakur/dotfiles`](https://github.com/sherubthakur/dotfiles)
- [`github:hlissner/dotfiles`](https://github.com/hlissner/dotfiles)
- [`github:dustinlyons/nixos-config`](https://github.com/dustinlyons/nixos-config)
- [`github:tars0x9752/home`](https://github.com/tars0x9752/home)
- [`github:Misterio77/nix-config`](https://github.com/Misterio77/nix-config)
- [`github:nix-community/todomvc-nix`](https://github.com/nix-community/todomvc-nix)

## Issues

### cannot link '/nix/store/.tmp-link-XX-XXXX' to '/nix/store/.links/XXXXX': File exists

This can happen when some derivation fails to build for any reason and one dependency gets a lock that is not released. Those get generated by `nix-store --optimize`.

Running `nix-store --optimise` can get a lot of `skipping suspicious writable file '/nix/store/XXXXXX'` messages.

**Try `nix-collect-garbage --max-freed 10m`.**

### VSCodium won't update

Usually accompanied by the message "An update is ready to install. Visual Studio Code is trying to add a new helper tool".

This is usually caused due to VSCod{e,ium} residing in a different path than `/Applications`. To fix, according to <https://github.com/Microsoft/vscode/issues/7426#issuecomment-277737150>:

```console
sudo chown $USER ~/Library/Caches/com.vscodium.ShipIt/* # or com.microsoft.VSCode.ShipIt/*
xattr -dr com.apple.quarantine ~/Applications/Home Manager Apps/VSCodium.app
```
