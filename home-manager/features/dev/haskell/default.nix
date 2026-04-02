{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      ghc

      cabal-install
      # cabal-gild
      # cabal-add
      # cabal-audit # broken

      haskell-language-server
      ghcid

      hoogle
    ];
  };
}
