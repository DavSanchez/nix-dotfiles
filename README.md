# Nix-based dotfiles

## [![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

[![CI](https://github.com/DavSanchez/nix-dotfiles/actions/workflows/builds.yml/badge.svg)](https://github.com/DavSanchez/nix-dotfiles/actions/workflows/builds.yml) [![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

## First-time setup

This repository is a **Nix Flake**. To use it, your Nix usage should have the experimental features `nix-command` and `flakes` enabled. See the [wiki](https://wiki.nixos.org/wiki/Flakes) for more details.

0. If you're on NixOS already there's not much else needed regarding applying system-level configs. Run `sudo nixos-rebuild switch --flake .#<HOSTNAME>` to apply the desired system configuration. To install NixOS, see the instructions on [the official site](https://nixos.org/download/).
1. (Non-NixOS), install Nix by going to <https://nixos.org/download/> and following instructions for your platform.
2. (macOS) If you want to use the `nix-darwin` configurations, install `nix-darwin` via switching to one of the existing configs directly with `sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake .#<HOSTNAME>`.
    - If there's no config you desire to apply just yet, follow the instructions to do a basic installation at [the `nix-darwin` repo](https://github.com/LnL7/nix-darwin).
3. To use the `home-manager` configurations, install `home-manager` via switching to one of the existing configs directly with `nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake .#<USER>@<HOSTNAME>`.
    - If you do not have an existing config that is applicable, follow the instructions to do a basic installation at [the `home-manager` repo](https://nix-community.github.io/home-manager/index.xhtml#ch-nix-flakes).
4. Enjoy!

To speed up the build processes, you can use my binary cache as substituter. If using `cachix`, you can enable it quickly with `cachix use davsanchez`, this would modify your local `~/.config/nix/nix.conf` adding my cache URL and public key.

## Uninstalling

You might want to get rid of the configs and the programs that manage it, either for temporary maintenance reasons (e.g. perhaps you were bit by [macOS Sequoia stepping over the builder users created by Nix](https://github.com/NixOS/nix/issues/10892), so you want to start from scratch to avoid any issues) or maybe because you just don't want to use Nix anymore. In any case, you can uninstall everything by going through these steps.

1. (macOS) Uninstall `nix-darwin` with `nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller`.
2. After running the command above you _might_ run into problems regarding SSL CA certs. With an error like this one:

    ```sh
    error: unable to download 'https://cache.nixos.org/d9l4i5phhrwy8f0yjp5yj4ri65z9cxzb.narinfo': Problem with the SSL CA cert (path? access rights?) (77)
    ```

    To fix this [issue](https://github.com/NixOS/nix/issues/8771#issuecomment-1662633816), restore the old link to `/etc/ssl/certs/ca-certificates.crt`:

    ```sh
    # Check that it exists with
    ls -la /etc/ssl/certs/ca-certificates.crt
    # Remove it and restore it
    sudo rm /etc/ssl/certs/ca-certificates.crt
    sudo ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
    ```

3. Uninstall `home-manager` via `nix --extra-experimental-features "nix-command flakes" run home-manager/master -- uninstall`.
4. (Non-NixOS) Uninstall Nix altogether, following the [uninstallation instructions](https://nix.dev/manual/nix/2.25/installation/uninstall.html) in the Nix Reference Manual.

The cool thing of Nix is that, any time you want to come back, you can get the exact same configs you last used (same program versions, everything) by repeating the installation commands above this section. Cool!

## Influences

Mainly the `nix-starter-configs` templates, but the repo might have diverged from it as of now. It's always interesting to check other people's configs though, after all you're checking mine :)

- [`github:misterio77/nix-starter-configs`](https://github.com/Misterio77/nix-starter-configs)
- [`github:sherubthakur/dotfiles`](https://github.com/sherubthakur/dotfiles)
- [`github:hlissner/dotfiles`](https://github.com/hlissner/dotfiles)
- [`github:dustinlyons/nixos-config`](https://github.com/dustinlyons/nixos-config)
- [`github:tars0x9752/home`](https://github.com/tars0x9752/home)
- [`github:Misterio77/nix-config`](https://github.com/Misterio77/nix-config)

## Further reading

- [Notes on Flakes by @zimbatm](https://zimbatm.com/notes/nixflakes)
- [Getting started with Nix Flakes and devshell](https://yuanwang.ca/posts/getting-started-with-flakes.html)
- [Flakes aren't real and cannot hurt you](https://jade.fyi/blog/flakes-arent-real)
