{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs.haskellPackages; [
     # Handled via Homebrew + ghcup in macOS until behavior is stabilized 
    ] ++ lib.optionals pkgs.stdenv.isLinux [
      ghc
      
      cabal-install
      stack
      
      haskell-language-server # Langserver
      implicit-hie
      
      hoogle
      hpack
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
        author-email = "davidslt@pm.me"; # config.programs.git.userEmail;
        github-username = "DavSanchez";
      };
    };
    nix.enable = true;
  };

  home.file.".summoner.toml".source = ./summoner.toml;
}
