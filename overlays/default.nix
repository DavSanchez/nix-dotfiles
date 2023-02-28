# This file defines overlays

{ inputs, ...}:
rec {
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

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable' 
  x86-darwin-packages = _final: _prev: {
    x86Darwin = import inputs.nixpkgs { 
      system = "x86_64-darwin";
      config.allowUnfree = true;
    };
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    let
      x86DarwinPkgs = (x86-darwin-packages { inherit inputs; }).x86Darwin;
    in
    {
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });
    } // prev.lib.optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
      kcctl = (additions x86DarwinPkgs null).kcctl;
      gdb = x86DarwinPkgs.gdb;
    };
}
