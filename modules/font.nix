{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.pakages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    fira-code
  ];
}
