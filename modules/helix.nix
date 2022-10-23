_: {
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        lsp.display-messages = true;
        color-modes = true;
        statusline = {
          left = ["mode" "spinner"];
        };
      };
      theme = "onedarker";
      # keys.normal = {
      #   space.space = "file_picker";
      #   space.w = ":w";
      #   space.q = ":q";
      # };
    };
    # themes = {  };
  };
}
