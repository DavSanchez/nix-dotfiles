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
    userName = "David Sánchez";
    userEmail = "davidslt+git@pm.me";

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

    delta = {
      enable = false;
      options = {
        features = "side-by-side line-numbers decorations";
        whitespace-error-style = "22 reverse";
        navigate = true;
        line-numbers = true;
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
        };
        delta.navigate = true;
      };
    };

    difftastic = {
      enable = false;
      background = "dark";
      color = "auto";
      display = "side-by-side";
    };

    diff-so-fancy = {
      enable = true;
      pagerOpts = [
        "--tabs=4"
        "-RFX"
      ];
    };

    extraConfig = {
      init.defaultBranch = "master";
      branch.sort = "-committerdate";
      pull.ff = "only";
      pull.rebase = true;

      pager.log = "diff-so-fancy | less --tabs=4 -RFX"; # delta
      pager.reflog = "diff-so-fancy | less --tabs=4 -RFX"; # delta
      pager.show = "diff-so-fancy | less --tabs=4 -RFX"; # delta
      pager.blame = "diff-so-fancy | less --tabs=4 -RFX"; # delta

      color.diff-highlight.oldNormal = "red bold";
      color.diff-highlight.oldHighlight = "red bold 52";
      color.diff-highlight.newNormal = "green bold";
      color.diff-highlight.newHighlight = "green bold 22";

      color.diff.meta = "yellow";
      color.diff.frag = "magenta bold";
      color.diff.commit = "yellow bold";
      color.diff.old = "red bold";
      color.diff.new = "green bold";
      color.diff.whitespace = "red reverse";

      color.status.added = "green bold";
      color.status.changed = "red bold";
      color.status.untracked = "magenta bold";

      color.branch.current = "yellow bold";
      color.branch.local = "yellow bold";
      color.branch.remote = "green bold";

      color.ui = "auto";

      color.interactive.prompt = "yellow";
      color.interactive.header = "cyan bold";
      color.interactive.help = "cyan bold";
      color.interactive.error = "red bold";
      color.interactive.option = "magenta bold";
      color.interactive.selected = "green bold";
    };

    aliases = {
      pushall = "!git remote | xargs -L1 git push --all";
      graph = "log --decorate --oneline --graph";
      add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --unidiff-zero -";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      # Workaround for https://github.com/nix-community/home-manager/issues/4744
      version = 1;
      git_protocol = "ssh";
    };
  };

  programs.gitui.enable = true;

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

  # programs.gpg.enable = pkgs.stdenv.isLinux;
  # services.gpg-agent.enable = pkgs.stdenv.isLinux;
}
