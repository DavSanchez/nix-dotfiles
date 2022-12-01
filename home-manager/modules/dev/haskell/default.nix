{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      haskellPackages.ghc
      
      haskellPackages.cabal-install
      stack
      
      haskellPackages.haskell-language-server # Langserver
      haskellPackages.implicit-hie
      
      haskellPackages.hoogle
      haskellPackages.hpack
    ];

    # hoogle ghci integration
    # example> :hoogle <$>
    file.".ghci".text = ''
      :def hoogle \x -> return $ ":!hoogle \"" ++ x ++ "\""
      :def doc \x -> return $ ":!hoogle --info \"" ++ x ++ "\""
    '';
  };

  # https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
  home.file.".stack/config.yaml".text = lib.generators.toYAML {} {
    system-ghc = true;
    install-ghc = false;
    templates = {
      scm-init = "git";
      params = {
        author-name = "David Sánchez"; # config.programs.git.userName;
        author-email = "davsanchez8@proton.me"; # config.programs.git.userEmail;
        github-username = "DavSanchez";
      };
    };
    nix.enable = true;
  };

  home.file.".summoner.toml".source = ./summoner.toml;
}