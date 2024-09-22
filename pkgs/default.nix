# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{ pkgs, ... }:
rec {
  # example = pkgs.callPackage ./example { };
  neonmodem = pkgs.callPackage ./neonmodem.nix { };

  xcodegen = pkgs.callPackage ./xcodegen.nix { };

  aerospace = pkgs.callPackage ./aerospace { inherit xcodegen; };
}
