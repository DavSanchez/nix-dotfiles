{pkgs, ...}: {
  home.packages = with pkgs; [
    bfg-repo-cleaner
    git-quick-stats
    git-crypt

    sapling
  ];
  programs.git = {
    enable = true;
    userName = "David Sánchez";
    userEmail = "davidslt+git@pm.me";

    includes = [{path = "~/.config/git/localconf";}];

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
      # core.editor = "hx";
      pull.ff = "only";
      pull.rebase = true;

      pager.log = "diff-so-fancy | less --tabs=4 -RFX"; # delta
      pager.reflog = "diff-so-fancy | less --tabs=4 -RFX"; # delta
      pager.show = "diff-so-fancy | less --tabs=4 -RFX"; # delta
      pager.blame = "diff-so-fancy | less --tabs=4 -RFX"; # delta

      diff-highlight = true;
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
      basicdiff = "diff --no-ext-diff";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.git_protocol = "ssh";
  };

  programs.gitui.enable = true;

  # programs.gpg.enable = pkgs.stdenv.isLinux;
  # services.gpg-agent.enable = pkgs.stdenv.isLinux;
}
