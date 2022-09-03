{ pkgs, ... }:
let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;

  # Helper function to cut down on boilerplate
  extension = { publisher, name, version, sha256 }:
    buildVscodeMarketplaceExtension {
      mktplcRef = { inherit name publisher sha256 version; };
    };
in
with pkgs.vscode-extensions; [
      # pinage404.nix-extension-pack
      rust-lang.rust-analyzer
      bungcip.better-toml
      golang.go
      haskell.haskell
      # vscode-icons-team.vscode-icons
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-azuretools.vscode-docker
      # jeppeandersen.vscode-kafka
      usernamehw.errorlens
      eamodio.gitlens
      # liviuschera.noctis
      # aaron-bond.better-comments
      # # * This creates a derivation for a VSCode Marketplace extension (useful!)
      # (extension {
      #   publisher = "BazelBuild";
      #   name = "vscode-bazel";
      #   version = "0.5.0";
      #   sha256 = "sha256-JJQSwU3B5C2exENdNsWEcxFSgWHnImYas4t/KLsgTj4=";
      # })
    ]
