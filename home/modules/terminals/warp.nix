{
  config,
  lib,
  options,
  ...
}:
let
  inherit (config.home) homeDirectory;

  # Warp has no catppuccin module upstream, so the theme is derived from the
  # palette the catppuccin flake already ships (catppuccin.sources.palette)
  # rather than hardcoding hex values.
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

  # catppuccin/nix exposes one option tree per app it themes. If it ever gains
  # a Warp module, that flake owns the theme and this file must stop declaring
  # one — fail the build so the duplication is noticed instead of drifting.
  upstreamWarpOptions =
    if options ? catppuccin then
      builtins.filter (name: lib.hasInfix "warp" (lib.toLower name)) (
        builtins.attrNames options.catppuccin
      )
    else
      [ ];
in
{
  # Warp is configured from plain files under ~/.warp on macOS. The module
  # symlinks settings.toml, keybindings.yaml and the themes/tab_configs dirs
  # into the store, so edits made in Warp's Settings panel do not persist —
  # declare them here instead.
  programs.warp-terminal = {
    enable = true;

    themes =
      lib.throwIf (upstreamWarpOptions != [ ])
        ''
          catppuccin/nix now declares ${lib.concatStringsSep ", " upstreamWarpOptions}, so it can
          theme Warp itself. Delete the `themes` and `settings.appearance.themes` blocks from
          home/modules/terminals/warp.nix and let the flake own the theme.
        ''
        (
          lib.optionalAttrs catppuccin.enable {
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
          }
        );

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

    # Workflows are Warp's parameterised commands (ctrl-shift-R). This one is
    # host-independent and has no `just` recipe: locate the option that sets
    # something in this repo.
    workflows.find_setting = {
      name = "Find where a dotfiles setting is declared";
      command = "rg -n --glob '*.nix' '{{pattern}}' ${homeDirectory}/.dotfiles";
      description = "Search the Nix sources for the option or value that sets something.";
      tags = [
        "nix"
        "dotfiles"
      ];
      arguments = [
        {
          name = "pattern";
          description = "Regex to search for, e.g. programs.ghostty";
          default_value = "programs.ghostty";
        }
      ];
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
