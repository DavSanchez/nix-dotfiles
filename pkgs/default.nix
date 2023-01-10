# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # example = pkgs.callPackage ./example { };
  kcctl = pkgs.callPackage ./kcctl.nix { };
  cotp = pkgs.callPackage ./cotp.nix { 
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit;
  };
  confluent-platform = pkgs.callPackage ./confluent-platform.nix { };
  confluent-cli = pkgs.callPackage ./confluent-cli.nix { };
}
