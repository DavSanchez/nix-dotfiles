{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    iosevka-bin
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.iosevka-term-slab

    fira-code-symbols
    nerd-fonts.fira-code

    jetbrains-mono
    nerd-fonts.jetbrains-mono

    monaspace
    nerd-fonts.monaspace

    maple-mono.NF

    # For sketchybar
    sketchybar-app-font
    nerd-fonts.hack
  ];
}
