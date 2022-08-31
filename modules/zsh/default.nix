{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = import ./aliases.nix;
    history.extended = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "vi-mode"
        "web-search"
        "aws"
        "terraform"
        "nomad"
        "vault"
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
    ];

    initExtraBeforeCompInit = ''
      ${builtins.readFile ./session_variables.zsh}
      ${if pkgs.stdenv.isDarwin then builtins.readFile ./session_variables.mac.zsh else ""}
      ${builtins.readFile ./functions.zsh}
      bindkey -M vicmd 'k' history-beginning-search-backward
      bindkey -M vicmd 'j' history-beginning-search-forward
      eval "$(direnv hook zsh)"
      eval "$(zoxide init zsh)"
      eval "$(starship init zsh)"
    '';

    # https://knezevic.ch/posts/zsh-completion-for-tools-installed-via-home-manager/
    # initExtra = ''
    #   fpath=(${config.xdg.configHome}/zsh/plugins/zsh-completions/src \
    #          ${config.xdg.configHome}/zsh/plugins/nix-zsh-completions \
    #          ${config.xdg.configHome}/zsh/vendor-completions \
    #          $fpath)
    # '';
  };

  # xdg.configFile."zsh/vendor-completions".source = with pkgs;
  #   runCommandNoCC "vendored-zsh-completions" {} ''
  #     mkdir -p $out
  #     ${fd}/bin/fd -t f '^_[^.]+$' \
  #       ${lib.escapeShellArgs home.packages} \
  #       --exec ${ripgrep}/bin/rg -0l '^#compdef' {} \
  #       | xargs -0 cp -t $out/
  #   '';
}
