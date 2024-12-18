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
    };

    # Other options:
    # configFile = ...;
    # envFile = ...;
    # loginFile = ...;

    extraConfig = ''
      # Theme from nu_scripts: catppuccin mocha
      source ${pkgs.nu_scripts}/share/nu_scripts/themes/nu-themes/catppuccin-mocha.nu

      # Aliases from nu_scripts
      source ${pkgs.nu_scripts}/share/nu_scripts/aliases/bat/bat-aliases.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/aliases/docker/docker-aliases.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/aliases/git/git-aliases.nu

      # Custom completions
      # TODO
    '';
    extraEnv = ''
      $env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin')

      $env.EDITOR = "${pkgs.helix}/bin/hx"
    '';
    # extraLogin = ...;

    # FIXME: forgit is not available
    shellAliases =
      {
        # git-forgit
        gflo = "forgit_log";
        gfrl = "forgit_reflog";
        gfd = "forgit_diff";
        gfa = "forgit_add";
        gfrh = "forgit_reset_head";
        gfi = "forgit_ignore";
        gfcf = "forgit_checkout_file";
        gfcb = "forgit_checkout_branch";
        gfbd = "forgit_branch_delete";
        gfct = "forgit_checkout_tag";
        gfco = "forgit_checkout_commit";
        gfrc = "forgit_revert_commit";
        gfclean = "forgit_clean";
        gfss = "forgit_stash_show";
        gfsp = "forgit_stash_push";
        gfcp = "forgit_cherry_pick";
        gfrb = "forgit_rebase";
        gfbl = "forgit_blame";
        gffu = "forgit_fixup";
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        open = "^open"; # ^ escapes the command and invokes the operating system one
      };

    # TODO enable this
    # plugins =
    #   with pkgs.nushellPlugins;
    #   [
    #     net
    #     skim
    #     units
    #     query
    #     gstat
    #     polars
    #     formats
    #     highlight
    #   ]
    #   ++ lib.optionals pkgs.stdenv.isLinux [ dbus ];
  };

  home.packages = with pkgs; [ nufmt ];
}
