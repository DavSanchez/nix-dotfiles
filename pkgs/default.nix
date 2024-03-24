# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{pkgs, ...}: {
  # example = pkgs.callPackage ./example { };
  # kcctl = pkgs.callPackage ./kcctl.nix {};
  # nvchad = pkgs.callPackage ./nvchad.nix {};
  neonmodem = pkgs.callPackage ./neonmodem.nix {};
}
