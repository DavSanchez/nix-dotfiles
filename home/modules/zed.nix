_: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "haskell"
      "toml"
      "rust"
      "go"
      "opencode"
      # "catppuccin-blur"
    ];
    # userKeymaps = { };
    userSettings = {
      auto_update = false;
      helix_mode = true;
      hour_format = "hour24";
      buffer_font_family = "Iosevka Slab";
      option_as_meta = false;
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
