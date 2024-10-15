{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs.haskellPackages; [
      ghc

      cabal-install
      # cabal-add
      # cabal-audit

      stack

      haskell-language-server # Langserver
      ghcid

      hoogle
    ];

    # hoogle ghci integration
    # example> :hoogle <$>
    file.".ghci".text = ''
      :def hoogle \x -> return $ ":!hoogle \"" ++ x ++ "\""
      :def doc \x -> return $ ":!hoogle --info \"" ++ x ++ "\""
    '';
    # https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
    file.".stack/config.yaml".text = lib.generators.toYAML { } {
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

    file.".summoner.toml".source = ./summoner.toml;

    # sessionPath = [ ] ++ lib.optionals pkgs.stdenv.isDarwin [
    #   # Handled via Homebrew + ghcup in macOS until behavior is stabilized
    #   "$HOME/.cabal/bin"
    #   "$HOME/.ghcup/bin"
    # ];
  };
}
