# This file defines overlays
{
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
      mkDarwinX86 = pkgname:
        prev.lib.optionalAttrs (prev.stdenv.system == "aarch64-darwin") x86DarwinPkgs.${pkgname};
    in
    {
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });
      purescript = mkDarwinX86 "purescript";
    };
}
