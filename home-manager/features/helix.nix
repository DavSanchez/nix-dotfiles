_: {
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        true-color = true;
        color-modes = true;
        # whitespace.render = "all";
        indent-guides.render = true;
      };
      theme = "rose_pine_moon";
      # keys.normal = {
      #   space.space = "file_picker";
      #   space.w = ":w";
      #   space.q = ":q";
      # };
    };
    # themes = {  };
  };
}
