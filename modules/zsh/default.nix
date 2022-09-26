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
          "aws"
          "bazel"
          "docker"
          "fd"
          "gh"
          "git"
          "git-extras"
          "gitfast"
          "github"
          "gitignore"
          "git-lfs"
          # "git-prompt"
          "golang"
          "gpg-agent"
          "helm"
          "kubectl"
          "lein"
          "nmap"
          "nomad"
          "otp"
          "pass"
          "ripgrep"
          "rust"
          "ssh-agent"
          "terraform"
          "tmux"
          "torrent"
          "urltools"
          "vi-mode"
          "vscode"
          "web-search"
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          "brew"
          "macos"
        ];
    };
    zplug = {
      enable = true;
      plugins = [
        {name = "chisui/zsh-nix-shell";}
        {name = "MichaelAquilina/zsh-you-should-use";}
      ];
    };
    plugins = [
      {
        name = "zsh-autopair";
        src = pkgs.fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "v1.0";
          sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
        };
        file = "autopair.zsh";
      }
    ];

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
