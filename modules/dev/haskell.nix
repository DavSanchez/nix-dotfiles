{ pkgs, ... }:

{
  home = {
    packages = with pkgs.haskellPackages; [
      # Haskell
      ghc
      cabal-install
      cabal2nix
      haskell-language-server
      hoogle
      stack
      hpack
      implicit-hie
    ];

    # hoogle ghci integration
    # example> :hoogle <$>
    file.".ghci".text = ''
      :def hoogle \x -> return $ ":!hoogle \"" ++ x ++ "\""
      :def doc \x -> return $ ":!hoogle --info \"" ++ x ++ "\""
    '';
  };
}
