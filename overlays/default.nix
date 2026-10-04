# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  # rosetta-packages = final: _prev: {
  #   rosetta = if final.stdenv.hostPlatform.isDarwin && final.stdenv.isAarch64 then final.pkgsx86_64Darwin else final;
  # };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: prev: {
    # Temporary: carry nu_scripts ahead of the pending nixpkgs update
    # (NixOS/nixpkgs#558481) so the abbreviations in home/modules/nu.nix exist.
    # Drop this once a nixpkgs bump ships nu_scripts >= the commit that added
    # share/nu_scripts/abbreviations/ (nushell/nu_scripts#1275, 2026-09-27).
    nu_scripts = prev.nu_scripts.overrideAttrs (_: {
      version = "0-unstable-2026-10-02";
      src = prev.fetchFromGitHub {
        owner = "nushell";
        repo = "nu_scripts";
        rev = "3ffc5aa43194bb4d5295dec9fbf0a18b3a2dddfc";
        hash = "sha256-/6nbTNfpkNRUJcXnQKw9yrm3UAvgfUoyKbNRUkQAfPY=";
      };
    });
  };
}
