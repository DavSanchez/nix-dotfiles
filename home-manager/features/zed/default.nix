{pkgs,...}: {
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "haskell"
      # "catppuccin-blur"
    ];
    # userKeymaps = { };
    userSettings = {
      vim_mode = true;
      vim = {
        default_mode = "helix_normal";
      };

      buffer_font_family = "Iosevka Slab Custom";
      load_direnv = "shell_hook";
      show_whitespaces = "all";
      autosave = {
        after_delay.milliseconds = 1000;
      };
      relative_line_numbers = true;
    };
    extraPackages = with pkgs; [
      rust-analyzer
      haskell-language-server
      nixd
    ];
    installRemoteServer = true;
  };
}
