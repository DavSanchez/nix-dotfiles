_: {
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      # "haskell" # FIXME Already present?
      "catppuccin"
      "TOML"
    ];
    userKeymaps = { };
    userSettings = {
      vim_mode = true;
    };
  };
}
