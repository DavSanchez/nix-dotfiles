{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    iosevka-bin
    (iosevka-bin.override { variant = "Slab"; })
    nerd-fonts.iosevka

    jetbrains-mono

    monaspace
    maple-mono.NF

    # For sketchybar
    # sketchybar-app-font
  ];
}
