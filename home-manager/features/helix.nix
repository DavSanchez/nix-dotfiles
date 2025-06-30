{ pkgs, config, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = [ ]; # For ading LSPs and stuff
    settings = {
      editor = {
        auto-save = true;
        cursorline = true;
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        soft-wrap = {
          enable = true;
        };
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          language-servers = [
            "nixd"
            "nil"
          ];
          formatter = {
            command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          };
        }
      ];
      language-server.nixd = {
        command = "${pkgs.nixd}/bin/nixd";
      };
    };
  };

}
