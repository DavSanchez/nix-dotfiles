{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Data visualzation/manipulation
    gawk
    gnused
    findutils
    fx
    hexyl
    jo
    fq
    dasel
    difftastic
    delta
    graphviz
    grex
    binsider
  ];

  programs.jq.enable = true;
}
