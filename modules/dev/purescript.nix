{pkgs, ...}: {
  home.packages = with pkgs; [
    purescript
    spago
    pscid
    nodePackages.purescript-language-server # Langserver

    dhall
    dhall-lsp-server # Langserver
  ];
}
