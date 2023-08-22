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

  outputs = inputs @ {
    self,
    nixpkgs,
    pre-commit-hooks,
    flake-utils,
    fenix,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      rustPackages = fenix.packages.${system}.stable;
    in {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            actionlint.enable = true;
            alejandra.enable = true;
            ansible-lint.enable = true;
            cargo-check.enable = true;
            clippy.enable = true;
            convco.enable = true;
            markdownlint.enable = true;
            rustfmt.enable = true;
            taplo.enable = true;
            terraform-format.enable = true;
            tflint.enable = true;
            yamllint.enable = true;
          };
          tools = {
            cargo = rustPackages.cargo;
            rustfmt = rustPackages.rustfmt;
            clippy = rustPackages.clippy;
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
          buildInputs = with pkgs;
            [
              rustPackages.toolchain
            ]
            ++ lib.optionals stdenv.isDarwin [
              libiconv
              darwin.apple_sdk.frameworks.Security
            ];
        };
      };

      # packages = { default = ... };
    });
}
