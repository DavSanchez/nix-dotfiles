_: {
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        color-modes = true;
        statusline = {
          left = ["mode" "spinner"];
        };
      };
      theme = "catppuccin_mocha";
      # keys.normal = {
      #   space.space = "file_picker";
      #   space.w = ":w";
      #   space.q = ":q";
      # };
    };
    # themes = {  };
  };
}
