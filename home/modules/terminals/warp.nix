{ config, lib, ... }:
let
  inherit (config.home) homeDirectory;

  # Warp has no catppuccin module upstream, so the theme is derived from the
  # palette the catppuccin flake already ships (catppuccin.sources.palette)
  # rather than hardcoding hex values. If catppuccin/nix ever grows a Warp
  # module, drop `themes` / the `appearance.themes` block below and let it own
  # them.
  catppuccin = config.catppuccin;
  palette = (lib.importJSON "${catppuccin.sources.palette}/palette.json").${catppuccin.flavor}.colors;
  flavorName =
    {
      latte = "Latte";
      frappe = "Frappé";
      macchiato = "Macchiato";
      mocha = "Mocha";
    }
    .${catppuccin.flavor};
  themeName = "Catppuccin ${flavorName}";
  themePath = "${homeDirectory}/.warp/themes/catppuccin_${catppuccin.flavor}.yaml";
in
{
  # Warp is configured from plain files under ~/.warp on macOS. The module
  # symlinks settings.toml, keybindings.yaml and the themes/tab_configs dirs
  # into the store, so edits made in Warp's Settings panel do not persist —
  # declare them here instead.
  programs.warp-terminal = {
    enable = true;

    themes = lib.optionalAttrs catppuccin.enable {
      "catppuccin_${catppuccin.flavor}" = {
        name = themeName;
        accent = palette.rosewater.hex;
        cursor = palette.rosewater.hex;
        background = palette.base.hex;
        foreground = palette.text.hex;
        details = "darker";
        terminal_colors = {
          normal = {
            black = palette.surface1.hex;
            red = palette.red.hex;
            green = palette.green.hex;
            yellow = palette.yellow.hex;
            blue = palette.blue.hex;
            magenta = palette.pink.hex;
            cyan = palette.teal.hex;
            white = palette.subtext0.hex;
          };
          bright = {
            black = palette.surface2.hex;
            red = palette.red.hex;
            green = palette.green.hex;
            yellow = palette.yellow.hex;
            blue = palette.blue.hex;
            magenta = palette.pink.hex;
            cyan = palette.teal.hex;
            white = palette.subtext1.hex;
          };
        };
      };
    };

    settings = {
      appearance = {
        vertical_tabs.enabled = true;
        text = {
          font_size = 13.0;
          notebook_font_size = 14.0;
        };
      }
      // lib.optionalAttrs catppuccin.enable {
        themes = {
          # system_theme = true would win over the custom theme below.
          system_theme = false;
          theme.custom = {
            name = themeName;
            path = themePath;
          };
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
  };
}
