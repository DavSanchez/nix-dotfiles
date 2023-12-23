{
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    defaultKeymap = "emacs";
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    shellAliases = import ./aliases.nix;
    history.extended = true;
    oh-my-zsh = {
      enable = true;
      plugins =
        [
          "aws"
          "cp"
          "docker"
          "docker-compose"
          # "emacs"
          "fd"
          "gh"
          "git"
          "git-auto-fetch"
          "git-extras"
          "gitfast"
          "github"
          "gitignore"
          "git-lfs"
          "golang"
          "helm"
          "kubectl"
          "minikube"
          "mix"
          "nmap"
          # "nomad"
          "pass"
          "ripgrep"
          "rust"
          # "ssh-agent"
          "terraform"
          "tmux"
          "torrent"
          "transfer"
          "urltools"
          "vi-mode"
          "vscode"
          "web-search"
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          "brew"
          "macos"
          "xcode"
        ];
    };

    antidote = {
      enable = true;
      plugins = [
        "chisui/zsh-nix-shell"
        "MichaelAquilina/zsh-you-should-use"
        "wfxr/formarks"
        "hlissner/zsh-autopair kind:defer"
      ];
    };

    sessionVariables = {
      KEYTIMEOUT = 1;
      DOTFILES = "$HOME/.dotfiles";
      NVIM_TUI_ENABLE_TRUE_COLOR = 1;
      EDITOR = "nvim";
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";
      # NIX_PATH = "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
      # FPATH = "$HOME/.nix-profile/share/zsh/site-functions:$FPATH";
      ZSH_AUTOSUGGEST_STRATEGY = ["history" "completion"];
    };

    initExtraBeforeCompInit = ''
      ${builtins.readFile ./functions.zsh}

      bindkey -M vicmd 'k' history-beginning-search-backward
      bindkey -M vicmd 'j' history-beginning-search-forward

      # ssh-agent (oh-my-zsh plugin) settings should be added before OMZ is sourced
      # lazy load (https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ssh-agent#lazy)
      # zstyle :omz:plugins:ssh-agent lazy yes
    '';

    # envExtra = '' '';

    profileExtra = ''
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        # Use path_helper
        if [ -x /usr/libexec/path_helper ]; then
          eval `/usr/libexec/path_helper -s`
        fi
        # Homebrew
        eval $(/opt/homebrew/bin/brew shellenv)
      ''}

      # Less variables (quoted inside sessionVariables so they don't work there)
      export LESS=-R
      export LESS_TERMCAP_mb=$'\E[1;31m' # begin blink
      export LESS_TERMCAP_md=$'\E[1;36m' # begin bold
      export LESS_TERMCAP_me=$'\E[0m' # reset bold/blink
      export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
      export LESS_TERMCAP_se=$'\E[0m' # reset reverse video
      export LESS_TERMCAP_us=$'\E[1;32m' # begin underline
      export LESS_TERMCAP_ue=$'\E[0m' # reset underline
    '';

    initExtra = ''
      # Add aliases for github-copilot-cli (other shells?)
      eval "$(${pkgs.github-copilot-cli}/bin/github-copilot-cli alias -- "$0")"
    '';
  };
}
