# This file defines overlays
let
  inherit (inputs.darwin.lib) darwinSystem;
  inherit (inputs.nixpkgs.lib) attrValues optionalAttrs singleton;
  # Configuration for `nixpkgs`
  nixpkgsConfig = {
    overlays =
      attrValues self.overlays
      ++ singleton (
        # Sub in x86 version of packages that don't build on Apple Silicon yet
        final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          inherit
            (final.pkgs-x86)
            # Add packages not available in aarch64-darwin:
            purescript
            ;
        })
      );
  };
in
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    apple-silicon =
      optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
        # Add access to x86 packages system is running Apple Silicon
        pkgs-x86 = import inputs.nixpkgs {
          system = "x86_64-darwin";
          inherit (nixpkgsConfig) config;
        };
      };
  };
}
