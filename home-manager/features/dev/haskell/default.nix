{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      ghc

      cabal-install
      # haskellPackages.cabal-gild
      # cabal-add
      # cabal-audit # broken

      haskell-language-server
      ghcid

      # haskellPackages.hoogle
    ];
  };
}
