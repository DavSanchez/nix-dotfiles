# This file defines overlays
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    let
      x86DarwinPkgs = (import ../nixpkgs.nix { system = "x86_64-darwin"; }).pkgs;
      mkDarwinX86 = pkgname:
        prev.lib.optionalAttrs (prev.stdenv.system == "aarch64-darwin") x86DarwinPkgs.${pkgname};
    in
    {
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });
      # apple-silicon = prev.optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
      #   # Add access to x86 packages system is running Apple Silicon
      #   pkgs-x86 = import inputs.nixpkgs-unstable {
      #     system = "x86_64-darwin";
      #     # inherit (nixpkgsConfig) config;
      #   };
      # };

      purescript = mkDarwinX86 "purescript";
    };
}
