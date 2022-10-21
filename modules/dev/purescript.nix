{pkgs, ...}: {
  home.packages = with pkgs; [
    haskellPackages.purescript
    spago
    pscid
    nodePackages.purescript-language-server

    dhall
    dhall-lsp-server
  ];
}
