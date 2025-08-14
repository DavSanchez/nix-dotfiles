{
  lib,
  pkgs,
  config,
  ...
}:
{
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
      cursor-click-to-move = true;
      auto-update = "check"; # Let Nix handle this while we use ghostty-bin
      # tmux-ifying ghostty!
      mouse-hide-while-typing = true;
      scrollback-limit = 1000000;
      window-save-state = "always";
      keybind = [
        "ctrl+h=goto_split:left"
        "ctrl+j=goto_split:bottom"
        "ctrl+k=goto_split:top"
        "ctrl+l=goto_split:right"

        "ctrl+b>h=new_split:left"
        "ctrl+b>j=new_split:down"
        "ctrl+b>k=new_split:up"
        "ctrl+b>l=new_split:right"
        "ctrl+b>f=toggle_split_zoom"

        "ctrl+b>n=next_tab"
        "ctrl+b>p=previous_tab"

        "super+r=reload_config"
      ]
      ++ lib.optionals (!pkgs.stdenv.isDarwin) [
        "ctrl+n=new_window"
      ];
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
