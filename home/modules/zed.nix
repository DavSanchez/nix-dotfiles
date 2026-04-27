{ pkgs, lib, ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "haskell"
      "toml"
      "rust"
      "go"
      "opencode"
      "justfile"
    ];
    # userKeymaps = { };
    userSettings = {
      terminal = {
        # font_size= 14.0;
        font_family = "Iosevka Term Slab";
        font_fallbacks = [
          "Menlo"
          "Monaco"
          "Courier New"
        ];
        max_scroll_history_lines = 5000;

        shell = {
          program = "${lib.getExe pkgs.fish}";
        };
        # scroll_multiplier = 3.0;
        # option_as_meta = true; # `true` prevents writing `#` on term as it applies to both sides
      };
      git = {
        inline_blame = {
          enabled = true;
        };
      };
      base_keymap = "VSCode"; # default
      git_panel = {
        fallback_branch_name = "master";
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
      show_edit_predictions = true;
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
      load_direnv = "shell_hook";
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
      };

      agent = {
        default_profile = "hermes";
        profiles = {
          hermes = {
            name = "Hermes";
            command = "hermes-acp";
            args = [ ];
          };
        };
      };
    };

    # extraPackages = [ ];
    installRemoteServer = true;
  };
}
