{pkgs, ...}: {
  home.packages = with pkgs; [
    purescript
    spago
    pscid

    dhall
    dhall-lsp-server
  ];
}
