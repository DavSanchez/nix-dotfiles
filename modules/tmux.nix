{ pkgs, ... }: {
  programs.zsh = {
    localVariables = {
      ZSH_TMUX_AUTOSTART = true;
      ZSH_TMUX_CONFIG = "$HOME/.config/tmux/tmux.conf";
    };
  };
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    baseIndex = 1;
    clock24 = true;

    # For vi mode
    # keyMode = "vi";
    # customPaneNavigationAndResize = true; # For vi mode
    # escapeTime = 0;

    historyLimit = 30000;
    extraConfig = ''
      # Default termtype. If the rcfile sets $TERM, that overrides this value.
      set -g terminal-overrides ',xterm-256color:Tc'
      # Create splits and vertical splits
      bind-key v split-window -h -p 50 -c "#{pane_current_path}"
      bind-key s split-window -p 50 -c "#{pane_current_path}"
      # Also use mouse
      setw -g mouse on
    '';

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      onedark-theme
      logging
      prefix-highlight
      sidebar
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];

    tmuxinator.enable = true;
    tmuxp.enable = true;
  };
}
