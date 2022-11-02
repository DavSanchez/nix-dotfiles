{pkgs, ...}: {
  home.packages = with pkgs; [
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
