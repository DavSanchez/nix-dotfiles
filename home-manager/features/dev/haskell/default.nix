{ pkgs, ... }:
{
  home = {
    packages = with pkgs.haskellPackages; [
      ghc

      cabal-install
      cabal-gild
      # cabal-add
      # cabal-audit

      # haskell-language-server # Langserver
      ghcid

      # hoogle
    ];
  };
}
