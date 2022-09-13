{ ... }:
{
  programs.zellij = {
    enable = true;
    settings = {
      template = {
        direction = "Horizontal";
        parts = [
          {
            direction = "Vertical";
            borderless = true;
            "split_size" = {
              "Fixed" = 1;
            };
            run = {
              plugin = {
                location = "zellij:tab-bar";
              };
            };
          }
          {
            direction = "Vertical";
            body = true;
          }
          {
            direction = "Vertical";
            borderless = true;
            "split_size" = {
              "Fixed" = 2;
            };
            run = {
              plugin = {
                location = "zellij:status-bar";
              };
            };
          }
        ];
      };
      tabs = [
        { name = "tab 1"; }
        {
          name = "tab 2";
          direction = "Vertical";
          parts = [
            { direction = "Horizontal"; }
            { direction = "Horizontal"; }
          ];
        }
        {
          name = "tab 3";
          direction = "Vertical";
          parts = [
            { direction = "Horizontal"; }
            {
              direction = "Horizontal";
              parts = [
                { direction = "Horizontal"; }
                { direction = "Vertical"; }
              ];
            }
          ];
        }
      ];
    };
  };
}
