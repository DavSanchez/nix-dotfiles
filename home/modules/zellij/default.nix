{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.self.homeModules.default-shell ];

  programs.zellij = {
    enable = true;

    settings = {
      ui.pane_frames.rounded_corners = true;
    }
    # Let's use the resolved default shell (nushell is bootstrapped through
    # fish/zsh so it inherits the nix-darwin environment).
    // lib.optionalAttrs (config.programs.defaultShell.command != null) {
      default_shell = config.programs.defaultShell.command;
    };
  };

  # Creating .config/zellij/layouts overwrites
  # the default config location for mac, hence
  # we create the config file here as well
  # xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
