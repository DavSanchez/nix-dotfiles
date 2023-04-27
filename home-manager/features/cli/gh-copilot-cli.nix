{ pkgs, ...}:
let
  gh-copilot-cli = pkgs.nodePackages."@githubnext/github-copilot-cli";
in
{
    home.packages = [
      gh-copilot-cli
    ];

    programs.zsh.initExtra = ''
      eval "$(${gh-copilot-cli}/bin/github-copilot-cli alias -- "$0")"
    '';
  }
