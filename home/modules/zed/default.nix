{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.self.homeModules.default-shell ];

  programs.zed-editor = {
    enable = true;
    extensions = [
      "clojure"
      "dockerfile"
      "go"
      "haskell"
      "just"
      "lean4"
      "make"
      "nix"
      "quint"
      "racket"
      "rust"
      "toml"
    ];
    # userKeymaps = { };
    userSettings = {
      cli_default_open_behavior = "existing_window";
      project_panel.dock = "left";
      outline_panel.dock = "left";
      collaboration_panel.dock = "left";
      agent = {
        dock = "right";
        favorite_models = [ ];
        model_parameters = [ ];
      };
      terminal = {
        # font_size= 14.0;
        font_family = "Iosevka Term Slab";
        font_fallbacks = [
          "Menlo"
          "Monaco"
          "Courier New"
        ];
        max_scroll_history_lines = 5000;
        # scroll_multiplier = 3.0;
        # option_as_meta = true; # `true` prevents writing `#` on term as it applies to both sides
      }
      // lib.optionalAttrs (config.programs.defaultShell.command != null) {
        shell = {
          program = config.programs.defaultShell.command;
        };
      };
      git = {
        inline_blame = {
          enabled = true;
        };
      };
      base_keymap = "VSCode"; # default
      git_panel = {
        fallback_branch_name = "master";
        tree_view = true;
      };
      # buffer_font_size = 14.0;
      buffer_font_fallbacks = [
        "Menlo"
        "Monaco"
        "Courier New"
      ];
      file_types = {
        haskell = [
          "*.tidal"
        ];
      };
      colorize_brackets = true;
      auto_indent_on_paste = true;
      # Note: ignored while autosave.after_delay is in effect (see `autosave`).
      format_on_save = "modifications_if_available";
      show_edit_predictions = true;
      edit_predictions = {
        provider = "copilot";
      };
      semantic_tokens = "combined";
      # wrap_guides = [ ];
      soft_wrap = "editor_width";
      # tab_size = 2;
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
      buffer_font_family = "Iosevka Slab";
      helix_mode = true;
      load_direnv = "direct";
      relative_line_numbers = "enabled";
      show_whitespaces = "all";
      auto_update = false;
      journal = {
        hour_format = "hour24";
      };
      diagnostics = {
        inline = {
          enabled = true;
        };
      };
      code_lens = "on";
      inlay_hints = {
        enabled = true;
      };

      lsp = {
        rust-analyzer = {
          initialization_options = {
            check = {
              command = "clippy";
            };
          };
        };
        nil = {
          initialization_options = {
            nix.flake.autoArchive = true;
          };
        };
      };

      agent_servers = {
        # ACP registry id (`zed: acp registry`), not an extension id.
        opencode-v2 = {
          default_config_options = {
            mode = "build";
            model = "opencode-go/deepseek-v4.1-flash";
          };
          type = "registry";
        };
      };
    };

    # extraPackages = [ ];
    installRemoteServer = true;
  };
}
