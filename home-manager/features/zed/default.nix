{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "haskell"
      # "catppuccin-blur"
    ];
    # userKeymaps = { };
    userSettings = {
      helix_mode = true;
      buffer_font_family = "Iosevka Slab Custom";
      load_direnv = "shell_hook";
      show_whitespaces = "all";
      autosave = {
        after_delay.milliseconds = 1000;
      };
      relative_line_numbers = true;
    };
    # extraPackages = [ ];
    installRemoteServer = true;
  };
}
