{
  description = "<ADD YOUR DESCRIPTION>";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    pre-commit-hooks,
    flake-utils,
    devenv,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              actionlint.enable = true;
              alejandra.enable = true;
              cabal-fmt.enable = true;
              cabal2nix.enable = true;
              convco.enable = true;
              fourmolu.enable = true;
              hlint.enable = true;
              hpack.enable = true;
              # hunspell.enable = true;
            };
            settings = {
              alejandra.exclude = ["default.nix"];
            };
          };
        };
        devShells = {
          default = pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            buildInputs = with pkgs.haskellPackages; [
              ghc
              cabal-install
              haskell-language-server
            ];
          };
          # devenv = devenv.lib.mkShell {};
        };
        packages = {
          default = pkgs.haskellPackages.callPackage ./default.nix {};
        };
      }
    );
}
