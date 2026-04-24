_: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "haskell"
      "toml"
      "rust"
      "go"
      "opencode"
    ];
    # userKeymaps = { };
    userSettings = {
      terminal = {
        # font_size= 14.0;
        font_family = "Iosevka Term Slab";
        font_fallbacks = [
          "FiraCode"
          "Menlo"
          "Monaco"
          "Courier New"
          "monospace"
        ];
        max_scroll_history_lines = 5000;
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
        "FiraCode"
        "Menlo"
        "Monaco"
        "Courier New"
        "monospace"
      ];
      file_types = {
        haskell = [
          "*.tidal"
        ];
      };
      colorize_brackets = true;
      auto_indent_on_paste = true;
      show_edit_predictions = true;
      semantic_tokens = "full";
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
      hour_format = "hour24";
      option_as_meta = false;

      diagnostics = {
        inline = {
          enabled = true;
        };
      };

      lsp = {
        rust-analyzer = {
          binary = {
            path_lookup = true;
          };
          initialization_options = {
            check = {
              command = "clippy";
            };
          };
        };
        nix = {
          binary = {
            path_lookup = true;
          };
        };
        haskell-language-server = {
          binary = {
            path_lookup = true;
          };
        };
      };
    };

    # extraPackages = [ ];
    installRemoteServer = true;
  };
}
