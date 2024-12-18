{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    iosevka # Allows for customization via privateBuildPlan

    iosevka-custom # From my overlay
    iosevka-term-custom # From my overlay
    iosevka-slab-custom # From my overlay
    iosevka-term-slab-custom # From my overlay

    fira-code-symbols
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono

    # For sketchybar
    sketchybar-app-font
    nerd-fonts.hack
  ];
}
