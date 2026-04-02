{ pkgs, ... }:
{
  home = {
    packages = (with pkgs; [
      ghc
      cabal-install
      haskell-language-server
      ghcid
    ]) ++ (with pkgs.haskellPackages; [
      cabal-gild
      cabal-add
      cabal-audit
      hoogle
    ]);
  };
}
