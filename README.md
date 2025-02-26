# Nix-based dotfiles

## [![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

[![CI](https://github.com/DavSanchez/nix-dotfiles/actions/workflows/builds.yml/badge.svg)](https://github.com/DavSanchez/nix-dotfiles/actions/workflows/builds.yml) [![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

## First-time setup

This repository is a **Nix Flake**. To use it, your Nix usage should have the experimental features `nix-command` and `flakes` enabled. See the [wiki](https://wiki.nixos.org/wiki/Flakes) for more details.

0. If you're on NixOS already there's not much else needed regarding applying system-level configs. Run `sudo nixos-rebuild switch --flake .#<HOSTNAME>` to apply the desired system configuration. To install NixOS, see the instructions on [the official site](https://nixos.org/download/).
1. (Non-NixOS), install Nix, preferably using the [Determinate Nix installer](https://github.com/DeterminateSystems/nix-installer). I recommend it because it has some functionalities that the official installer still does not have, such as enabling the `flakes` experimental feature by default, but **read just below**.
    - This installer will suggest installing Determinate System's downstream distribution for Nix, setting certain configs and adding other utilities, all of them tiered to enterprise/corporate usage. Vanilla Nix is enough for (almost) all use cases. The installer will prompt you something along the lines of `Cut the fuss with Determinate Nix?` to which you can press `[n]o` and continue with the standard Nix installation. I hope [they make this *opt-in* instead](https://github.com/DeterminateSystems/nix-installer/issues/1463).
    - You can always install with the official Nix installation script instead, with `sh <(curl -L <https://nixos.org/nix/install>)`.
2. (macOS) If you want to use the `nix-darwin` configurations, install `nix-darwin` via switching to one of the existing configs directly with `nix run nix-darwin/master#darwin-rebuild -- switch --flake .#<HOSTNAME>`.
    - If there's no config you desire to apply just yet, follow the instructions to do a basic installation at [the `nix-darwin` repo](https://github.com/LnL7/nix-darwin).
3. To use the `home-manager` configurations, install `home-manager` via switching to one of the existing configs directly with `nix run home-manager/master -- switch --flake .#<USER>@<HOSTNAME>`.
    - If you do not have an existing config that is applicable, follow the instructions to do a basic installation at [the `home-manager` repo](https://nix-community.github.io/home-manager/index.xhtml#ch-nix-flakes).
4. Enjoy!

To speed up the build processes, you can use my binary cache as substituter. If using `cachix`, you can enable it quickly with `cachix use davsanchez`, but this would modify your local `~ /.config/nix/nix.conf` which is not very declarative. I have configured it in this flake's `nixConfig`, but when running some builds for the first time your user might not be considered trusted, so the config might be ignored with a warning. This will change when you configure Nix to [trust your user](https://github.com/DavSanchez/nix-dotfiles/blob/f9e048b42920b12d2149be350314c91d9ed1739f/hosts/darwin/sierpe.nix#L61). I'll try to elaborate more on how to use this in the future.

## Uninstalling

You might want to get rid of the configs and the programs that manage it, either for temporary maintenance reasons (e.g. at the time of writing this, `nix-darwin` recommends to just reinstall Nix if you're manually bumping a config's [`stateVersion`](https://daiderd.com/nix-darwin/manual/index.html#opt-system.stateVersion), though generally you should not be doing that) or maybe because you just don't want to use Nix anymore (you should not be doing that either :D). In any case, you can uninstall everything by going through these steps.

1. (macOS) Uninstall `nix-darwin` with `nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller`.
2. After running the command above you might run into problems regarding SSL CA certs. With an error like this one:

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

3. Uninstall `home-manager` via `nix run home-manager/master -- uninstall`.
4. (Non-NixOS) Uninstall Nix altogether.
    - If you used the Determinate Nix installer, just do `/nix/nix-installer uninstall`.
    - If you used the standard Nix installation script, follow the [uninstall instructions](https://nix.dev/manual/nix/2.25/installation/uninstall.html) in the Nix Reference Manual.

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

## Issues that might happen

### VSCode and derivatives (VSCodium) won't update

Usually accompanied by the message "An update is ready to install. Visual Studio Code is trying to add a new helper tool".

This is usually caused due to VSCod{e,ium} residing in a different path than `/Applications`. To fix, according to <https://github.com/Microsoft/vscode/issues/7426#issuecomment-277737150>:

```console
sudo chown $USER ~/Library/Caches/com.vscodium.ShipIt/* # or com.microsoft.VSCode.ShipIt/*
xattr -dr com.apple.quarantine ~/Applications/Home\ Manager\ Apps/VSCodium.app # Or Visual\ Studio\ Code.app
```
