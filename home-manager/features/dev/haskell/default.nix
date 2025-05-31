{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs.haskellPackages; [
      ghc

      ormolu

      cabal-install
      cabal-gild
      # cabal-add
      # cabal-audit

      haskell-language-server # Langserver
      ghcid
      ghcide

      hoogle
    ];

    # hoogle ghci integration
    # example> :hoogle <$>
    file.".ghci".text = ''
      :def hoogle \x -> return $ ":!hoogle \"" ++ x ++ "\""
      :def doc \x -> return $ ":!hoogle --info \"" ++ x ++ "\""
    '';
    # https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
    file.".stack/config.yaml" = {
      enable = false;
      text = lib.generators.toYAML { } {
        system-ghc = true;
        install-ghc = false;
        templates = {
          scm-init = "git";
          params = {
            author-name = "David Sánchez"; # config.programs.git.userName;
            author-email = "davidslt@pm.me"; # config.programs.git.userEmail;
            github-username = "DavSanchez";
          };
        };
        nix.enable = true;
      };
    };

    file.".summoner.toml" = {
      enable = false;
      source = ./summoner.toml;
    };
  };
}
