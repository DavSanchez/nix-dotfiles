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
      __fish_command_not_found_handler = {
        body = "__fish_default_command_not_found_handler $argv[1]";
        onEvent = "fish_command_not_found";
      };
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    interactiveShellInit = ''
      fish_config theme choose "Rosé Pine Moon"

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

      # Change greeting
      set -U fish_greeting "🐟"

      # Nix shell for non-Bash shells
      ${pkgs.nix-your-shell}/bin/nix-your-shell fish | source
    '';

    loginShellInit = "";

    plugins =
      map gen-plugin [
        "grc" # grc Colourizer for some commands on Fish shell
        "forgit" # Utility tool powered by fzf for using git interactively (adds abbrvs!)
        "fzf-fish" # Augment your fish command line with fzf key bindings
        "done" # Automatically receive notifications when long processes finish
        "colored-man-pages" # Fish shell plugin to colorize man pages
        "bass" # Fish function making it easy to use utilities written for Bash in Fish shell
        "autopair" # Auto-complete matching pairs in the Fish command line
        "clownfish" # Fish function to mock the behaviour of commands
      ]
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
      ];

    shellAbbrs = { };

    shellAliases = { };

    shellInit = "";

    shellInitLast = "";
  };

  xdg.configFile."fish/themes" = {
    source = ./themes;
    recursive = true;
  };

  # For the "grc" plugin enabled above, we need grc as it does not provide the package
  home.packages = lib.optionals config.programs.fish.enable [ pkgs.grc ];
}
