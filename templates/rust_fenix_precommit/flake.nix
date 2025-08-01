{
  description = "<ADD YOUR DESCRIPTION>";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      pre-commit-hooks,
      flake-utils,
      fenix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        rustPackages = fenix.packages.${system}.stable;
      in
      {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              actionlint.enable = true;
              cargo-check.enable = true;
              clippy.enable = true;
              convco.enable = true;
              markdownlint.enable = true;
              nixfmt = {
                enable = true;
                package = pkgs.nixfmt-rfc-style;
              };
              rustfmt.enable = true;
              taplo.enable = true;
              terraform-format.enable = true;
              tflint.enable = true;
              yamllint.enable = true;
            };
            tools = {
              inherit (rustPackages) cargo clippy rustfmt;
            };
            settings = {
              clippy = {
                allFeatures = true;
                # denyWarnings = true;
              };
            };
          };
        };
        devShells = {
          default = pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            buildInputs = [
              rustPackages.toolchain
            ]
            ++ (
              with pkgs;
              lib.optionals stdenv.isDarwin [
                libiconv
                darwin.apple_sdk.frameworks.Security
              ]
            );
          };
        };

        # packages = { default = ... };
      }
    );
}
