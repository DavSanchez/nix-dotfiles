{ pkgs, config, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        true-color = true;
        color-modes = true;
        # whitespace.render = "all";
        indent-guides.render = true;
      };
      keys.normal = {
        "C-y" = ":sh ${pkgs.zellij}/bin/zellij run -f -x 10% -y 10% --width 80% --height 80% -- ${pkgs.bash}/bin/bash ${config.xdg.configHome}/helix/yazi-picker.sh";
      };
      # teme = "rose_pine_moon";
    };
    languages = {
      language = [
        {
          name = "nix";
          language-servers = [ "nixd" ];
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

  xdg.configFile."helix/yazi-picker.sh".text = ''
        paths=$(${pkgs.yazi}/bin/yazi --chooser-file=/dev/stdout | while read -r; do printf "%q " "$REPLY"; done)

        if [[ -n "$paths" ]]; then
    	    ${pkgs.zellij}/bin/zellij action toggle-floating-panes
    	    ${pkgs.zellij}/bin/zellij action write 27 # send <Escape> key
    	    ${pkgs.zellij}/bin/zellij action write-chars ":open $paths"
    	    ${pkgs.zellij}/bin/zellij action write 13 # send <Enter> key
    	    ${pkgs.zellij}/bin/zellij action toggle-floating-panes
        fi

        ${pkgs.zellij}/bin/zellij action close-pane
  '';
}
