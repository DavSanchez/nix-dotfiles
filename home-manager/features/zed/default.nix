{pkgs,...}: {
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "haskell"
      "elixir"
      "make"
      "helm"
      # "catppuccin" # added with catppuccin-nix
      # "catppuccin-icons" # added with catppuccin-nix
      "catppuccin-blur"
    ];
    userKeymaps = { };
    userSettings = {
      vim_mode = true;

      buffer_font_family = "Iosevka Slab Custom";
      load_direnv = "shell_hook";
      show_whitespaces = "all";
      autosave = {
        after_delay.milliseconds = 1000;
      };
    };
    extraPackages = with pkgs; [
      rust-analyzer
      haskell-language-server
      nixd
      elixir-ls
      helm-ls
    ];
    installRemoteServer = true;
  };
}
