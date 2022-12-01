{ pkgs, ... }: {
  home.packages = with pkgs; [
    # https://discourse.purescript.org/t/recommended-tooling-for-purescript-in-2022/3206
    purescript
    spago

    esbuild

    nodePackages.purescript-language-server # Langserver
    nodePackages.purs-tidy
    nodePackages.purescript-psa
    # purescript-backend-optimizer # Not available yet

    pscid

    dhall
    dhall-lsp-server # Langserver
  ];
}
