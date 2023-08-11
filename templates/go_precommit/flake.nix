{
  description = "New Relic Infrastructure Agent";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    pre-commit-hooks,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            actionlint.enable = true;
            alejandra.enable = true;
            ansible-lint.enable = true;
            convco.enable = true;
            gofmt.enable = true;
            gotest.enable = true;
            govet.enable = true;
            markdownlint.enable = true;
            rustfmt.enable = true;
            shellcheck.enable = true;
            staticcheck.enable = true;
            terraform-format.enable = true;
            tflint.enable = true;
            yamllint.enable = true;
          };
        };
      };
      devShells = {
        default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = with pkgs; [
            go
            go-tools
            golangci-lint
            goreleaser
          ];
        };
      };

      # packages = { default = ... };
    });
}
