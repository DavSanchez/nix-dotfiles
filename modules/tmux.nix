{ pkgs, ... }:
let
  github-tmux-onedark-src = pkgs.fetchFromGitHub {
    owner = "odedlaz";
    repo = "tmux-onedark-theme";
    rev = "3607ef889a47dd3b4b31f66cda7f36da6f81b85c";
    sha256 = "19jljshwp2p83b634cd1mw69091x42jj0dg40ipw61qy6642h2m5";
  };
in
{
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
    shortcut = "a";
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
      # Hack to add onedark theme
      run-shell ${github-tmux-onedark-src}/tmux-onedark-theme.tmux
      # Pssible additional info: https://yuanwang.ca/posts/tmux-nix.html
    '';

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
    ];

    tmuxinator.enable = true;
    tmuxp.enable = true;
  };
}
