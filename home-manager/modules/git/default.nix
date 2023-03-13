{pkgs, ...}:
with builtins; let
  DEFAULT_BRANCH = "master";
  DEVELOP_BRANCH = "develop";
  DEVELOP_BRANCH_ABBREV = "dev";
  PROTECTED_BRANCHES_LIST = [DEFAULT_BRANCH DEVELOP_BRANCH DEVELOP_BRANCH_ABBREV];
  PROTECTED_BRANCHES_STR = concatStringsSep "|" PROTECTED_BRANCHES_LIST;
in {
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
      enable = true;
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

    extraConfig = {
      init.defaultBranch = DEFAULT_BRANCH;
      branch.sort = "-committerdate";
      core.editor = "hx";
      pull.ff = "only";
      pull.rebase = true;
    };

    aliases = {
      pushall = "!git remote | xargs -L1 git push --all";
      graph = "log --decorate --oneline --graph";
      add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --unidiff-zero -";
    };
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings.git_protocol = "ssh";
  };

  programs.gitui.enable = true;

  # programs.gpg.enable = pkgs.stdenv.isLinux;
  # services.gpg-agent.enable = pkgs.stdenv.isLinux;
}
