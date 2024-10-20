{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Hack"
        "Iosevka"
        "JetBrainsMono"
      ];
    })
    fira-code-symbols
    iosevka # Allows for customization via privateBuildPlan
    sketchybar-app-font
  ];
}
