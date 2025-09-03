{
  pkgs,
  lib,
  config,
  ...
}:
let
  gen-plugin = pkg: {
    name = "${pkg}";
    inherit (pkgs.fishPlugins.${pkg}) src;
  };
in
{
  programs.fish = {
    enable = true;

    functions = {
      # __fish_command_not_found_handler = {
      #   body = "__fish_default_command_not_found_handler $argv[1]";
      #   onEvent = "fish_command_not_found";
      # };
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    interactiveShellInit = ''
      ${lib.optionalString pkgs.stdenv.isDarwin "/opt/homebrew/bin/brew shellenv | source"}
      # https://fishshell.com/docs/current/interactive.html#vi-mode
      set -g fish_key_bindings fish_vi_key_bindings

      # Some emacs keybindings even though I'm using vi mode
      bind -M default \ca beginning-of-line
      bind -M insert \ca beginning-of-line
      bind -M default \ce end-of-line
      bind -M insert \ce end-of-line
      bind -M default \cb backward-char
      bind -M insert \cb backward-char
      bind -M default \cf forward-char
      bind -M insert \cf forward-char
      bind -M default \cq backward-bigword
      bind -M insert \cq backward-bigword
      bind -M default \cw forward-bigword
      bind -M insert \cw forward-bigword
      bind -M default \cz complete-and-search
      bind -M insert \cz complete-and-search

      # fifc plugin setup and keybinding
      set -Ux fifc_editor hx
      set -U fifc_keybinding \cx

      # Change greeting
      set -U fish_greeting "🐟"
    '';

    loginShellInit = "";

    plugins =
      map gen-plugin (
        [
          "grc" # grc Colourizer for some commands on Fish shell
          "forgit" # Utility tool powered by fzf for using git interactively (adds abbrvs!)
          "plugin-git" # Git plugin for fish (similar to oh-my-zsh git)
          # "fzf-fish" # Augment your fish command line with fzf key bindings
          "fifc" # Configurable fzf completions for fish shell
          "done" # Automatically receive notifications when long processes finish
          "colored-man-pages" # Fish shell plugin to colorize man pages
          "bass" # Fish function making it easy to use utilities written for Bash in Fish shell
          "foreign-env" # Foreign environment interface for Fish shell
          "autopair" # Auto-complete matching pairs in the Fish command line
          "clownfish" # Fish function to mock the behaviour of commands
          # "async-prompt" # Make prompt asynchronous to improve the reactivity
          "plugin-sudope" # Fish plugin to quickly put 'sudo' in your command
          "fish-you-should-use" # Fish plugin that reminds you to use your aliases
          "puffer" # Text Expansions for Fish
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          "macos"
        ]
      )
      ++ [
        # {
        #   name = "fish-abbreviation-tips";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "gazorby";
        #     repo = "fish-abbreviation-tips";
        #     rev = "v0.7.0";
        #     sha256 = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
        #   };
        # }
        {
          name = "fish-utils-core";
          src = pkgs.fetchFromGitHub {
            owner = "halostatue";
            repo = "fish-utils-core";
            rev = "v3.2.0";
            sha256 = "sha256-XHOuxw0vZLQEv3q0ZYa4ERnO/sTNMugZB/uy0Zu8hxU=";
          };
        }
      ];

    shellAbbrs = { };

    shellAliases = { };

    shellInit = '''';

    shellInitLast = ''
      ${lib.optionalString config.programs.starship.enable "enable_transience"}
    '';
  };

  # In fish, the contents of .config/fish/conf.d (e.g. plugins) get executed BEFORE config.fish
  # So, if I want to override the aliases defined in the forgit plugin I need to place
  # something in .config/fish/conf.d and ensure it runs before forgit!
  xdg.configFile."fish/conf.d/00-forgit-preload.fish".text = ''
    set -gx forgit_log gflo
    set -gx forgit_reflog gfrl
    set -gx forgit_diff gfd
    set -gx forgit_add gfa
    set -gx forgit_reset_head gfrh
    set -gx forgit_ignore gfi
    set -gx forgit_checkout_file gfcf
    set -gx forgit_checkout_branch gfcb
    set -gx forgit_branch_delete gfbd
    set -gx forgit_checkout_tag gfct
    set -gx forgit_checkout_commit gfco
    set -gx forgit_revert_commit gfrc
    set -gx forgit_clean gfclean
    set -gx forgit_stash_show gfss
    set -gx forgit_stash_push gfsp
    set -gx forgit_cherry_pick gfcp
    set -gx forgit_rebase gfrb
    set -gx forgit_blame gfbl
    set -gx forgit_fixup gffu
  '';

  # For the "grc" plugin enabled above, we need grc as it does not provide the package
  home.packages = lib.optionals config.programs.fish.enable [ pkgs.grc ];
}
