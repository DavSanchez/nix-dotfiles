{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    shellAliases = import ./aliases.nix;
    history.extended = true;
    localVariables = {
      ZSH_TMUX_AUTOSTART = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "vi-mode"
        "web-search"
        "bazel"
        "docker"
        "aws"
        "terraform"
        "nomad"
        "helm"
        "kubectl"
        "fd"
        "ripgrep"
        "torrent"
        "gh"
        "git-extras"
        "gitfast"
        "github"
        "gitignore"
        "git-lfs"
        # "git-prompt"
        "vscode"
        "urltools"
        "golang"
        "rust"
        "pass"
      ] ++ lib.optionals pkgs.stdenv.isDarwin [
        "macos"
        "brew"
      ];
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
      {
        name = "nix-zsh-completions";
        file = "nix-zsh-completions.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "spwhitt";
          repo = "nix-zsh-completions";
          rev = "0.4.4";
          sha256 = "Djs1oOnzeVAUMrZObNLZ8/5zD7DjW3YK42SWpD2FPNk=";
        };
      }
      {
        name = "zsh-abbr";
        file = "zsh-abbr.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "olets";
          repo = "zsh-abbr";
          rev = "v4.8.0";
          sha256 = "diitszKbu530zXbJx4xmfOjLsITE9ucmWdsz9VTXsKg=";
        };
      }
    ];

    initExtraBeforeCompInit = ''
      ${builtins.readFile ./session_variables.zsh}
      ${if pkgs.stdenv.isDarwin then builtins.readFile ./session_variables.mac.zsh else ""}
      ${builtins.readFile ./functions.zsh}

      bindkey -M vicmd 'k' history-beginning-search-backward
      bindkey -M vicmd 'j' history-beginning-search-forward
    '';

    # envExtra = '' '';

    profileExtra = ''
      eval $(/opt/homebrew/bin/brew shellenv)
      
      # Homebrew
      # Homebrew sbin
      export PATH="$(brew --prefix)/sbin:$PATH"
      # Homebrew completions
      FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
      # Haskell for ARM needs to have LLVM available (At least for the moment)
      export PATH="$(brew --prefix llvm)/bin:${"\${PATH}"}"
    '';

    # https://knezevic.ch/posts/zsh-completion-for-tools-installed-via-home-manager/
    # initExtra = ''
    #   [[ $TERM_PROGRAM != "vscode" ]] && eval "$(zellij setup --generate-auto-start zsh)"
    # '';
  };
}
