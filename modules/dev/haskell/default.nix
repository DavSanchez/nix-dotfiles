{
  lib,
  pkgs,
  ...
}: let
   inherit (pkgs.haskell.lib) disableCabalFlag;
  hlsWithoutOrmolus = pkgs.haskellPackages.haskell-language-server.override {
    # supportedGhcVersions = [ "924" ];
    hls-fourmolu-plugin = null;
    hls-ormolu-plugin = null;
  };
  withoutFourmoluF = disableCabalFlag hlsWithoutOrmolus "fourmolu";
  hls = disableCabalFlag withoutFourmoluF "ormolu";
in {
  home = {
    packages = with pkgs; [
      hls # My own overlay # Langserver
      ghc
      cabal-install
      cabal2nix
      # haskell-language-server # Langserver
      stack
      hpack
      haskellPackages.hoogle
      haskellPackages.implicit-hie
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
