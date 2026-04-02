{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      ghc

      cabal-install
      haskellPackages.cabal-gild
      haskellPackages.cabal-add
      # cabal-audit # broken

      haskell-language-server
      ghcid

      haskellPackages.hoogle
    ];
  };
}
