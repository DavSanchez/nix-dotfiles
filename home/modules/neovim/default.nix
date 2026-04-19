_: {
  programs.nixvim = {
    enable = false;
    enableMan = true;
    viAlias = true;
    vimAlias = true;

    globals = import ./globals.nix;
    colorschemes = import ./colorschemes.nix;
    # highlight = import ./highlight.nix;
    keymaps = import ./keymaps.nix;
    opts = import ./options.nix;
    plugins = import ./plugins;
  };
}
