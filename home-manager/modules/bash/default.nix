{ pkgs, ...}:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };
}