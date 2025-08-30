{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.nushell = {
    enable = true;
    environmentVariables = {
      DOTFILES = "${config.home.homeDirectory}/.dotfiles";
      EDITOR = "${pkgs.helix}/bin/hx";
    };

    # configFile = ...;
    # envFile = ...;
    # loginFile = ...;

    extraConfig = ''
      # Aliases from nu_scripts
      source ${pkgs.nu_scripts}/share/nu_scripts/aliases/bat/bat-aliases.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/aliases/eza/eza-aliases.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/aliases/docker/docker-aliases.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/aliases/git/git-aliases.nu

      # Custom completions
      # TODO
    '';
    # extraEnv = ...;
    # extraLogin = ...;

    settings = {
      highlight_resolved_externals = true;
    };

    plugins =
      with pkgs.nushellPlugins;
      [
        # net # currently broken (not compatible with nu version)
        skim
        # units # currently broken (not compatible with nu version)
        query
        gstat
        polars
        # semver # not available for macOS
        formats
        highlight
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [ dbus ];
  };

  home.packages = with pkgs; [ nufmt ];
}
