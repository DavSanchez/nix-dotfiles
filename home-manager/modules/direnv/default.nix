{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    # stdlib = ''
    #   ${builtins.readFile ./project_layouts/poetry.sh}
    # '';
  };
}
