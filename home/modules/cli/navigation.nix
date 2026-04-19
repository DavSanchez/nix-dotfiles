_: {
  programs = {
    yazi = {
      enable = true;
      shellWrapperName = "y";

      keymap = { };
      settings = { };
      theme = { };
    };

    broot = {
      enable = true;

      settings.verbs = [
        {
          invocation = "custom_panel_right";
          key = "shift-right";
          execution = ":panel_right";
        }
        {
          invocation = "custom_panel_left";
          key = "shift-left";
          execution = ":panel_left";
        }
      ];
    };
  };
}
