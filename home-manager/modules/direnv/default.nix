{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    # enableFishIntegration = true;    # Already enabled by default and read-only
    # enableNushellIntegration = true; # Already enabled by default and read-only
    # stdlib = ''
    #   ${builtins.readFile ./project_layouts/poetry.sh}
    # '';
  };
}
