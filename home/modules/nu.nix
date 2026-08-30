{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.nushell = {
    enable = true;
    environmentVariables = {
      DOTFILES = "${config.home.homeDirectory}/.dotfiles";
      EDITOR = "${pkgs.helix}/bin/hx";
    };

    # configFile = ...;
    # envFile = ...;
    # loginFile = ...;

    extraConfig = ''
      # Aliases from nu_scripts
      source ${pkgs.nu_scripts}/share/nu_scripts/aliases/bat/bat-aliases.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/aliases/eza/eza-aliases.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/aliases/docker/docker-aliases.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/aliases/git/git-aliases.nu

      # Custom completions
    '';
    # extraEnv = ...;
    # extraLogin = ...;

    shellAliases = {
      # fish's gitignore function, ported
      gitignore = "curl -sL https://www.gitignore.io/api";
    };

    settings = {
      highlight_resolved_externals = true;
      show_banner = false;
      # Helix-style selection-first editing (nushell 0.115+)
      edit_mode = "helix";
      buffer_editor = "hx";
      cursor_shape = {
        helix_normal = "block";
        helix_select = "block";
        helix_insert = "line";
      };
      # OSC 133 for ghostty shell integration (cwd + command marks)
      shell_integration = {
        osc133 = true;
      };
      # Fish-style abbreviations (nushell 0.113+), expanded on space/enter
      abbreviations = {
        # ls family (mirrors the fish aliases; `eza` itself is aliased by home-manager)
        ls = "eza";
        la = "eza -a";
        ll = "eza -l";
        lla = "eza -la";
        lt = "eza --tree";

        # git (curated from fish's plugin-git; `gcm` intentionally differs from
        # nu_scripts' alias so it matches fish's `git commit -m`)
        g = "git";
        ga = "git add";
        gaa = "git add --all";
        gau = "git add --update";
        gapa = "git add --patch";
        gb = "git branch";
        gba = "git branch --all";
        gbl = "git blame -b -w";
        gbd = "git branch -d";
        gco = "git checkout";
        gcb = "git checkout -b";
        gc = "git commit --verbose";
        gca = "git commit --verbose --all";
        gcm = "git commit -m";
        gcam = "git commit --all -m";
        gcl = "git clone";
        gclean = "git clean -di";
        gcp = "git cherry-pick";
        gd = "git diff";
        gdca = "git diff --cached";
        gds = "git diff --stat";
        gdt = "git diff-tree --no-commit-id --name-only -r";
        gf = "git fetch";
        gfa = "git fetch --all --prune";
        gfo = "git fetch origin";
        gl = "git pull";
        gll = "git pull origin";
        glr = "git pull --rebase";
        glo = "git log --oneline --decorate --color";
        glg = "git log --stat";
        glgg = "git log --graph";
        gm = "git merge";
        gma = "git merge --abort";
        gp = "git push";
        gpo = "git push origin";
        gpu = "git push origin (git branch --show-current) --set-upstream";
        gr = "git remote --verbose";
        gra = "git remote add";
        grb = "git rebase";
        grba = "git rebase --abort";
        grbc = "git rebase --continue";
        grbi = "git rebase --interactive";
        grbs = "git rebase --skip";
        grev = "git revert";
        grh = "git reset";
        grhh = "git reset --hard";
        grm = "git rm";
        grs = "git restore";
        grst = "git restore --staged";
        gsh = "git show";
        gsb = "git status --short --branch";
        gss = "git status --short";
        gst = "git status";
        gsta = "git stash push";
        gstaa = "git stash apply";
        gstd = "git stash drop";
        gstl = "git stash list";
        gstp = "git stash pop";
        gsw = "git switch";
        gswc = "git switch --create";
        gignore = "git update-index --assume-unchanged";
        gunignore = "git update-index --no-assume-unchanged";
        gup = "git pull --rebase";
        gwt = "git worktree";
        gwta = "git worktree add";
      };
    };

    plugins =
      with pkgs.nushellPlugins;
      [
        # net # currently broken (not compatible with nu version)
        # units # currently broken (not compatible with nu version)
        query
        gstat
        # polars
        # semver # currently broken (not compatible with nu version)
        formats
        # highlight # currently broken (not compatible with nu version)
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ dbus ];
  };

  home.packages = with pkgs; [ nufmt ];
}
