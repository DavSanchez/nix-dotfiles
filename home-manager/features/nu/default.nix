{ pkgs, config, ... }:
let
  nix-your-shell-config-nu = pkgs.runCommand "nix-your-shell-config-nu" { } ''
    ${pkgs.nix-your-shell}/bin/nix-your-shell "nu" >> "$out"
  '';
in
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

    extraConfig = ''
      source ${nix-your-shell-config-nu}
    '';
    # extraEnv = ...;
    # extraLogin = ...;

    # shellAliases = ...;
  };

  home.packages = with pkgs; [ nufmt ];
}
