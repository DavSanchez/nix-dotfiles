{ lib, pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    installBatSyntax = true;
    installVimSyntax = true;

    settings = {
      theme = "catppuccin-mocha";
      font-family = "Iosevka Term Slab Custom";
      font-size = 14;
      background-opacity = 0.8;
      background-blur-radius = 20;
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      keybind = [
        "alt+left=unbind"
        "alt+right=unbind"
      ];
      macos-option-as-alt = "left";
    };
  };
}
