{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    # stdlib = ''
    #   ${builtins.readFile ./project_layouts/poetry.sh}
    # '';
  };
}
