{ pkgs, ... }:
{
  home = {
    packages = with pkgs.haskellPackages; [
      ghc

      cabal-install
      cabal-gild
      cabal-add
      # cabal-audit # broken

      haskell-language-server
      ghcid

      hoogle
    ];
  };
}
