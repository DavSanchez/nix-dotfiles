{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "JetBrainsMono" ]; })
    fira-code
    iosevka
  ];
}
