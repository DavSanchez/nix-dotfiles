{ lib, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    installBatSyntax = true;
    installVimSyntax = true;

    settings =
      {
        theme = "catppuccin-mocha";
        font-family = "Iosevka Term Slab Custom";
        font-size = 14;
        background-opacity = 0.8;
        background-blur-radius = 20;
        cursor-click-to-move = true;
        # (lib.optionalString config.programs.fish.enable "command = \"${config.programs.fish.package}/bin/fish\"")
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        keybind = [
          "alt+left=unbind"
          "alt+right=unbind"
        ];
        macos-option-as-alt = "left";
      };
  };
}
