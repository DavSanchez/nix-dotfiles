# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{pkgs ? (import ../nixpkgs.nix) {}}: {
  # example = pkgs.callPackage ./example { };
  kcctl = pkgs.callPackage ./kcctl.nix {};
  infrastructure-agent = pkgs.callPackage ./infrastructure-agent.nix {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation IOKit Security;
    buildGoModule = pkgs.buildGo119Module;
  };
}
