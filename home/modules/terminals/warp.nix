{ config, ... }:
let
  inherit (config.home) homeDirectory;
  themeName = "Catppuccin Mocha";
in
{
  # Warp is configured from plain files under ~/.warp on macOS. The module
  # symlinks settings.toml, keybindings.yaml and the themes/tab_configs/
  # workflows dirs into the store, so edits made in Warp's Settings panel do
  # not persist — declare them here instead.
  programs.warp-terminal = {
    enable = true;
    # Warp's schema only knows ~15 built-in themes and no catppuccin, so the
    # official theme (catppuccin/warp) is inlined to carry a display name.
    themes.catppuccin_mocha = {
      name = themeName;
      accent = "#f5e0dc";
      cursor = "#f5e0dc";
      background = "#1e1e2e";
      foreground = "#cdd6f4";
      details = "darker";
      terminal_colors = {
        normal = {
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#a6adc8";
        };
        bright = {
          black = "#585b70";
          red = "#f37799";
          green = "#89d88b";
          yellow = "#ebd391";
          blue = "#74a8fc";
          magenta = "#f2aede";
          cyan = "#6bd7ca";
          white = "#bac2de";
        };
      };
    };

    settings = {
      appearance = {
        themes = {
          # system_theme = true would win over the custom theme below.
          system_theme = false;
          theme.custom = {
            name = themeName;
            path = "${homeDirectory}/.warp/themes/catppuccin_mocha.yaml";
          };
        };
        vertical_tabs.enabled = true;
        text = {
          font_size = 13.0;
          notebook_font_size = 14.0;
        };
      };
      general.default_session_mode = "agent";
      agents = {
        third_party.should_render_cli_agent_toolbar = true;
        warp_agent = {
          is_any_ai_enabled = false;
          other = {
            show_agent_notifications = true;
            show_conversation_history = true;
          };
        };
      };
      code.editor = {
        show_code_review_button = true;
        show_project_explorer = true;
        show_global_search = true;
      };
      warp_drive.enabled = true;
    };

    keybindings = {
      # Ctrl-R is the shell's reverse search far more often than Warp's
      # command search; move the latter out of the way.
      "workspace:show_command_search" = "shift-cmd-r";
      # macOS pane/editing keys, pinned so a Warp update can't move them.
      "pane_group:add_right" = "cmd-d";
      "pane_group:add_down" = "shift-cmd-D";
      "terminal:reinput_commands" = "cmd-i";
    };

    tabConfigs.dotfiles = {
      name = "Dotfiles";
      color = "green";
      panes = [
        {
          id = "root";
          split = "horizontal";
          children = [
            "editor"
            "shell"
          ];
        }
        {
          id = "editor";
          type = "terminal";
          directory = "${homeDirectory}/.dotfiles";
          commands = [
            "nix develop"
            "hx ."
          ];
          is_focused = true;
        }
        {
          id = "shell";
          type = "terminal";
          directory = "${homeDirectory}/.dotfiles";
        }
      ];
    };

    workflows = {
      home_switch = {
        name = "Rebuild this Mac's Home Manager config";
        command = "home-manager switch --flake ~/.dotfiles#david@sierpe";
        tags = [
          "nix"
          "dotfiles"
        ];
        description = "Apply the sierpe Home Manager configuration.";
      };
      flake_update = {
        name = "Update a flake input";
        command = "nix flake update {{input}}";
        tags = [
          "nix"
          "dotfiles"
        ];
        description = "Update one flake input, then review flake.lock.";
        arguments = [
          {
            name = "input";
            description = "Flake input name";
            default_value = "nixpkgs";
          }
        ];
      };
    };
  };
}
