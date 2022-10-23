{pkgs, ...}: {
  home.packages = with pkgs; [
    haskellPackages.purescript
    spago
    pscid
    nodePackages.purescript-language-server # Langserver

    dhall
    dhall-lsp-server # Langserver
  ];
}
