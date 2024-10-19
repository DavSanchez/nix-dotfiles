# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{ pkgs, ... }:
{
  # example = pkgs.callPackage ./example { };
  binsider = pkgs.callPackage ./binsider.nix { };
  kontroll = pkgs.callPackage ./kontroll.nix { };
}
