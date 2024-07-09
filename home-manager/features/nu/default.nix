{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    environmentVariables = {
      DOTFILES = "$HOME/.dotfiles";
    };

    # Other options:
    # configFile = ...;
    # envFile = ...;
    # loginFile = ...;

    # extraConfig = ...;
    # extraEnv = ...;
    # extraLogin = ...;

    # shellAliases = ...;
  };

  home.packages = with pkgs; [ nufmt ];
}
