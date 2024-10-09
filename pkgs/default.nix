# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{ pkgs, ... }:
{
  # example = pkgs.callPackage ./example { };
  neonmodem = pkgs.callPackage ./neonmodem.nix { };
  binsider = pkgs.callPackage ./binsider.nix { };
}
