{ pkgs, ... }:

{
  programs.vscode = {
    extensions = with pkgs.vscode-extensions; [
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
      # (buildVscodeMarketplaceExtension {
      #   mktplcRef = {
      #     name = "markdown-preview-github-styles";
      #     publisher = "bierner";
      #     version = "0.1.6";
      #     sha256 = "sha256-POIrekEkrYVj7MU9ZXToLIV0pl2X8PUBOQuuB4Mykt4=";
      #   };
      #   meta = { license = lib.licenses.mit; };
      # })
    ];
  };
}
