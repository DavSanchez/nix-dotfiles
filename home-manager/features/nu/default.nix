{ pkgs, config, ... }:
{
  programs.nushell = {
    enable = true;
    environmentVariables = {
      DOTFILES = "${config.home.homeDirectory}/.dotfiles";
    };

    # Other options:
    # configFile = ...;
    # envFile = ...;
    # loginFile = ...;

    extraConfig = '''';
    # extraEnv = ...;
    # extraLogin = ...;

    # shellAliases = ...;
  };

  home.packages = with pkgs; [ nufmt ];
}
