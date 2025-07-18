{
  lib,
  pkgs,
  config,
  ...
}:
{
  programs.ghostty =
    {
      enable = true;
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
          auto-update = "check"; # Let Nix handle this while we use ghostty-bin
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          # keybind = [
          #   "alt+left=unbind"
          #   "alt+right=unbind"
          # ];
          macos-option-as-alt = "left";
        }
        // lib.optionalAttrs config.programs.fish.enable {
          command = "${config.programs.fish.package}/bin/fish";
        };
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      package = pkgs.ghostty-bin;
    };
}
