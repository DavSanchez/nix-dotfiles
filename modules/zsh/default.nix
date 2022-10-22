{ config
, lib
, pkgs
, ...
}: {
  home.packages = with pkgs; [ ];
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
          "cp"
          "docker"
          "docker-compose"
          "fd"
          "gh"
          "git"
          "git-auto-fetch"
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
          "minikube"
          "mix"
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
          "transfer"
          "urltools"
          "vi-mode"
          "vscode"
          "web-search"
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          "brew"
          "iterm2"
          "macos"
          "xcode"
        ];
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "chisui/zsh-nix-shell"; }
        { name = "MichaelAquilina/zsh-you-should-use"; }
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

    initExtraBeforeCompInit = ''${builtins.readFile ./session_variables.zsh}''
      + lib.optionalString pkgs.stdenv.isDarwin (builtins.readFile ./session_variables.mac.zsh)
      + ''
      ${builtins.readFile ./functions.zsh}

      bindkey -M vicmd 'k' history-beginning-search-backward
      bindkey -M vicmd 'j' history-beginning-search-forward

      # ssh-agent (oh-my-zsh plugin) settings should be added before OMZ is sourced
      # lazy load (https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ssh-agent#lazy)
      zstyle :omz:plugins:ssh-agent lazy yes
    '';

    # envExtra = '' '';

    profileExtra = ''''
      + lib.optionalString pkgs.stdenv.isDarwin ''
      # Use path_helper
      if [ -x /usr/libexec/path_helper ]; then
        eval `/usr/libexec/path_helper -s`
      fi
      # Homebrew
      eval $(/opt/homebrew/bin/brew shellenv)
      # Homebrew sbin
      export PATH="$(brew --prefix)/sbin:$PATH"
      # Homebrew completions
      FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
      # Haskell for ARM needs to have LLVM available (At least for the moment)
      export PATH="$(brew --prefix llvm)/bin:${"\${PATH}"}"
    '';

    initExtra = ''
      # Do not add command to history if prepended by space
      setopt HIST_IGNORE_SPACE
    '';
  };
}
