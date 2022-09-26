{pkgs, ...}: {
  home.packages = with pkgs; [
    purescript
    spago
    pscid
    nodePackages.purescript-language-server

    dhall
    dhall-lsp-server
  ];
}
