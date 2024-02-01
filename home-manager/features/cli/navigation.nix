{pkgs, ...}: {
  programs = {
    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      keymap = {};
      settings = {};
      theme = {};
    };

    # broot = {
    #   enable = false;
    #   enableZshIntegration = true;
    #   enableBashIntegration = true;
    #   enableFishIntegration = true;
    #   settings.verbs = [
    #     {
    #       invocation = "custom_panel_right";
    #       key = "shift-right";
    #       execution = ":panel_right";
    #     }
    #     {
    #       invocation = "custom_panel_left";
    #       key = "shift-left";
    #       execution = ":panel_left";
    #     }
    #   ];
    # };
  };
}
