{
  pkgs,
  config,
  lib,
  ...
}:
let
  # Bootstrap nushell from fish so it inherits the nix-darwin environment
  # (nix-darwin has no nushell shell-init to source; fish loads it even as a script).
  nu-bootstrap = pkgs.writeScriptBin "nu-bootstrap" ''
    #!${lib.getExe config.programs.fish.package}
    exec ${lib.getExe config.programs.nushell.package} $argv
  '';
in
{
  programs.zellij = {
    enable = true;

    settings = {
      ui.pane_frames.rounded_corners = true;
    }
    # Let's use nushell as the default shell (if enabled)
    // lib.optionalAttrs (config.programs.nushell.enable && config.programs.fish.enable) {
      default_shell = "${nu-bootstrap}/bin/nu-bootstrap";
    };
  };

  # Creating .config/zellij/layouts overwrites
  # the default config location for mac, hence
  # we create the config file here as well
  # xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
