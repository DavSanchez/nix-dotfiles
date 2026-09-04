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
  modifications = final: prev: {
    # nixpkgs' omniwm is still on 0.6.3; pin to 0.6.4 until it catches up
    omniwm = prev.omniwm.overrideAttrs (_old: {
      version = "0.6.4";
      src = final.fetchurl {
        url = "https://github.com/BarutSRB/OmniWM/releases/download/v0.6.4/OmniWM-v0.6.4.zip";
        hash = "sha256-myv1TSDWf1NicAMuBiUXbAbG4DuIl93wJVWNlIM55ec=";
      };
    });
  };
}
