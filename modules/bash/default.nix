{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [];
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # shellAliases = import ./aliases.nix;
    # initExtra = '''';
    # profileExtra = '''';
  };
}
