{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    shellAliases = import ./aliases.nix;
    history.extended = true;
    oh-my-zsh = {
      enable = true;
      plugins =
        [
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
          "otp"
          "tmux"
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          "macos"
          "brew"
        ];
    };
    plugins = [];
    zplug = {
      enable = true;
      plugins = [
        {name = "chisui/zsh-nix-shell";}
        {name = "MichaelAquilina/zsh-you-should-use";}
        {
          name = "hlissner/zsh-autopair";
          tags = ["defer:2"];
        }
      ];
    };

    initExtraBeforeCompInit = ''
      ${builtins.readFile ./session_variables.zsh}
      ${
        if pkgs.stdenv.isDarwin
        then builtins.readFile ./session_variables.mac.zsh
        else ""
      }
      ${builtins.readFile ./functions.zsh}

      bindkey -M vicmd 'k' history-beginning-search-backward
      bindkey -M vicmd 'j' history-beginning-search-forward
    '';

    # envExtra = '' '';

    profileExtra =
      if pkgs.stdenv.isDarwin
      then ''
        eval $(/opt/homebrew/bin/brew shellenv)

        # Homebrew
        # Homebrew sbin
        export PATH="$(brew --prefix)/sbin:$PATH"
        # Homebrew completions
        FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
        # Haskell for ARM needs to have LLVM available (At least for the moment)
        export PATH="$(brew --prefix llvm)/bin:${"\${PATH}"}"
      ''
      else '''';

    # https://knezevic.ch/posts/zsh-completion-for-tools-installed-via-home-manager/
    # initExtra = ''
    #   [[ $TERM_PROGRAM != "vscode" ]] && eval "$(zellij setup --generate-auto-start zsh)"
    # '';
  };
}
