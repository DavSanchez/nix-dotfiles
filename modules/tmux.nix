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
      set -g status-right ' #{?client_prefix,#[reverse]<Prefix>#[noreverse] ,}"#{=21:pane_title}" %H:%M %d-%b-%y'
      bind-key Tab display-menu -T "#[align=centre]Sessions" "Switch" . 'choose-session -Zw' Last l "switch-client -l" ${tmuxMenuSeparator} \
        "Open Main Workspace" m "display-popup -E \" td ${cfg.mainWorkspaceDir} \"" "Open Sec Workspace" s "display-popup -E \" td ${cfg.secondaryWorkspaceDir} \""   ${tmuxMenuSeparator} \
        "Kill Current Session" k "run-shell 'tmux switch-client -n \; tmux kill-session -t #{session_name}'"  "Kill Other Sessions" o "display-popup -E \"tkill \"" ${tmuxMenuSeparator} \
        Random r "run-shell 'tat random'" Neovim e "run-shell 'tnvim'" ${tmuxMenuSeparator} \
        Exit q detach"

      # Hack to add onedark theme
      run-shell ${github-tmux-onedark-src}/tmux-onedark-theme.tmux
    '';

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
    ];

    tmuxinator.enable = true;
    tmuxp.enable = true;
  };
}
