{
  lib,
  config,
  ...
}:
{
  xdg.configFile."ghostty/config".text = lib.strings.concatStrings [
    "font-family = \"Iosevka Term Slab Custom\""
    "font-size = 14"
    "theme = catppuccin-mocha"
    "background-opacity = 0.8"
    "background-blur-radius = 20"
    "cursor-click-to-move = true"
    (lib.optionalString config.programs.fish.enable "command = ${config.programs.fish.package}/bin/fish")
  ];
}
