{ pkgs, ... }:

{
  home = {
    packages = with pkgs.haskellPackages; [
      # Haskell
      cabal2nix
      ghc
      haskell-language-server
      hoogle
      cabal-install
      stack
    ];

    # hoogle ghci integration
    # example> :hoogle <$>
    file.".ghci".text = ''
      :def hoogle \x -> return $ ":!hoogle \"" ++ x ++ "\""
      :def doc \x -> return $ ":!hoogle --info \"" ++ x ++ "\""
    '';
  };
}
