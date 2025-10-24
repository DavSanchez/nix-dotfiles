{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    bfg-repo-cleaner
    git-quick-stats
    git-crypt

    # sapling
  ];
  programs.git = {
    enable = true;

    # Move to localconf? Currently specifying on separate files
    # signing = {
    #   key = "...";
    #   signByDefault = true;
    # };

    includes = [ { path = "~/.config/git/localconf"; } ];

    ignores = [
      ".vscode/"
      "**/*.davs*/" # Put not-to-commit stuff in this directory
      "*.local"
      ".envrc"
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ".DS_Store"
    ];

    settings = {
      user = {
        name = "David Sánchez";
        email = "davidslt+git@pm.me";
      };

      alias = {
        pushall = "!git remote | xargs -L1 git push --all";
        graph = "log --decorate --oneline --graph";
        add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --unidiff-zero -";
      };

      init.defaultBranch = "master";
      branch.sort = "-committerdate";
      merge.conflictStyle = "zdiff3";

      pull = {
        ff = "only";
        rebase = true;
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = { };
  };

  programs.gitui.enable = false;

  # Git-compatible DVCS that is both simple and powerful
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "davidslt+jj@pm.me";
        name = "David Sánchez";
      };
    };
  };
  programs.jjui.enable = true;

  # programs.gpg.enable = pkgs.stdenv.isLinux;
  # services.gpg-agent.enable = pkgs.stdenv.isLinux;

  # diffs

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
    };
  };
}
