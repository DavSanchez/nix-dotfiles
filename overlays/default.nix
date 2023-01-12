# This file defines overlays
rec {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    let
      x86DarwinPkgs = (import ../nixpkgs.nix { 
        system = "x86_64-darwin";
        config.allowUnfree = true;
      }).pkgs;
    in
    {
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });
    } // prev.lib.optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
      purescript = x86DarwinPkgs.purescript;
      kcctl = (additions x86DarwinPkgs null).kcctl;
      gdb = x86DarwinPkgs.gdb;
    };
}
