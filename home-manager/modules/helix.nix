_: {
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        true-color = true;
        color-modes = true;
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
