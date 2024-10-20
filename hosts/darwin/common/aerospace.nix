_: {
  services = {
    aerospace = {
      enable = true;

      settings = {
        # Notify Sketchybar about workspace change
        exec-on-workspace-change = [
          "/bin/bash"
          "-c"
          "sketchybar --trigger aerospace_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE"
        ];
      };
    };
  };
}
