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
      # Colored man pages via bat (fish had `colored-man-pages`)
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
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

      # Fish-style abbreviations from nu_scripts (nushell 0.113+), expanded on
      # space/enter. Sourced after the aliases because composed abbreviations
      # (e.g. `gstu`) expand to text that still relies on the plain aliases.
      # Requires nu_scripts >= the commit adding abbreviations/ (nushell/nu_scripts#1275).
      source ${pkgs.nu_scripts}/share/nu_scripts/abbreviations/bat/bat-abbreviations.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/abbreviations/eza/eza-abbreviations.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/abbreviations/docker/docker-abbreviations.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/abbreviations/git/git-abbreviations.nu

      # Fetch a gitignore template from gitignore.io
      def gi [...targets: string] {
          if ($targets | is-empty) {
              print "Usage: gi <target1> <target2> ..."
              return
          }

          let query = $targets | str join ","
          let url = $"https://www.gitignore.io/api/($query)"

          http get --raw $url
      }
    '';
    # extraEnv = ...;
    # extraLogin = ...;

    shellAliases = { };

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
      # Emacs-style word movements in helix mode (not bound by default in 0.115+)
      keybindings = [
        {
          name = "move_word_left";
          modifier = "alt";
          keycode = "char_b";
          mode = [
            "helix_insert"
            "helix_normal"
            "helix_select"
          ];
          event = {
            edit = "MoveWordLeft";
          };
        }
        {
          name = "move_word_right";
          modifier = "alt";
          keycode = "char_f";
          mode = [
            "helix_insert"
            "helix_normal"
            "helix_select"
          ];
          event = {
            edit = "MoveWordRight";
          };
        }
        {
          name = "move_word_left_arrow";
          modifier = "alt";
          keycode = "left";
          mode = [
            "helix_insert"
            "helix_normal"
            "helix_select"
          ];
          event = {
            edit = "MoveWordLeft";
          };
        }
        {
          name = "move_word_right_arrow";
          modifier = "alt";
          keycode = "right";
          mode = [
            "helix_insert"
            "helix_normal"
            "helix_select"
          ];
          event = {
            edit = "MoveWordRight";
          };
        }
      ];
      # OSC 133 for ghostty shell integration (cwd + command marks)
      shell_integration = {
        osc133 = true;
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
