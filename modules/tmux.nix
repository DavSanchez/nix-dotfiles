{pkgs, ...}: {
  programs.zsh = {
    localVariables = {
      ZSH_TMUX_AUTOSTART = true;
      # ZSH_TMUX_FIXTERM_WITH_256COLOR = "xterm-256color";
      ZSH_TMUX_CONFIG = "$HOME/.config/tmux/tmux.conf";
      ZSH_TMUX_AUTOCONNECT = false;
      ZSH_TMUX_AUTOQUIT = false;
    };
  };
  programs.tmux = {
    terminal = "xterm-256color";
    enable = true;
    # baseIndex = 1;
    clock24 = true;
    # keyMode = "vi";
    # customPaneNavigationAndResize = true; # For vi mode
    # secureSocket = false;
    # shortcut = "a"; # Clashes with emacs keyMode
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
    ];

    tmuxinator.enable = true;
    tmuxp.enable = true;
  };
}
