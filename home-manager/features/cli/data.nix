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
    graphviz
    grex
    binsider
    magika
  ];

  programs.jq.enable = true;
}
