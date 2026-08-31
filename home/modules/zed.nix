{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Bootstrap nushell from fish so it inherits the nix-darwin environment
  # (nix-darwin has no nushell shell-init to source; fish loads it even as a script).
  nu-bootstrap = pkgs.writeScriptBin "nu-bootstrap" ''
    #!${lib.getExe config.programs.fish.package}
    exec ${lib.getExe config.programs.nushell.package} $argv
  '';
in
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "dockerfile"
      "go"
      "haskell"
      "just"
      "make"
      "nix"
      "opencode"
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
      // lib.optionalAttrs (config.programs.nushell.enable && config.programs.fish.enable) {
        shell = {
          program = "${nu-bootstrap}/bin/nu-bootstrap";
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
        nil = {
          nix.flake.autoArchive = true;
        };
      };

      agent_servers = {
        opencode = {
          default_config_options = {
            model = "opencode-go/deepseek-v4-flash";
          };
          type = "registry";
        };
        hermes-agent = {
          type = "custom";
          command = "hermes";
          args = [ "acp" ];
        };
      };
    };

    # extraPackages = [ ];
    installRemoteServer = true;
  };
}
