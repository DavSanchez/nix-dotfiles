pkgs:
let
  tmux-shell-profile = {
    "path" = "${pkgs.tmux}/bin/tmux";
    "args" = [
      "new-session"
      "-A"
      "-s"
      "vscode:\${workspaceFolder}"
    ];
  };
  zellij-shell-profile = {
    "path" = "${pkgs.zellij}/bin/zellij";
    "args" =
      [
        "--layout"
        "compact"
        # "attach"
        # "--create"
        # "vscode::\${workspaceFolderBasename}"
        "options"
        "--no-pane-frames"
        "--simplified-ui=true"
      ]
      ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
        "--copy-command"
        "pbcopy"
      ];
  };
  term-profiles = {
    "tmux" = tmux-shell-profile;
    "zellij" = zellij-shell-profile;
  };
in
{
  "breadcrumbs.enabled" = true;
  "diffEditor.ignoreTrimWhitespace" = false;
  "editor.accessibilitySupport" = "off";
  "editor.bracketPairColorization.enabled" = true;
  "editor.cursorSmoothCaretAnimation" = "on";
  "editor.fontFamily" = "'FiraCode Nerd Font', Menlo, Monaco, 'Courier New', monospace";
  "editor.fontLigatures" = true;
  "editor.formatOnPaste" = true;
  "editor.formatOnSave" = true;
  "editor.inlineSuggest.enabled" = true;
  "editor.minimap.renderCharacters" = false;
  "editor.renderControlCharacters" = false;
  "editor.renderWhitespace" = "all";
  "editor.rulers" = [
    {
      "color" = "#808080";
      "column" = 100;
    }
  ];
  "editor.stickyScroll.enabled" = true;
  "editor.suggestSelection" = "first";
  "editor.tabSize" = 2;
  "editor.wordWrap" = "on";
  "files.associations" = {
    "*.tidal" = "haskell";
  };
  "files.autoSave" = "afterDelay";
  "git.autofetch" = true;
  "git.defaultBranchName" = "master";
  "nix.formatterPath" = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
  "rust-analyzer.check.command" = "clippy";
  "search.exclude" = {
    "**/.direnv" = true;
  };
  "terminal.external.osxExec" = "WezTerm.app";
  "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
  "terminal.integrated.scrollback" = 5000;
  "terminal.integrated.shellIntegration.enabled" = true;
  "terminal.integrated.profiles" = {
    "linux" = term-profiles;
    "osx" = term-profiles;
  };
  "terminal.integrated.defaultProfile" = {
    "linux" = "zellij";
    "osx" = "zellij";
  };
  "vim.enableNeovim" = true; # programs.neovim.enable;
  "vim.neovimUseConfigFile" = true; # programs.neovim.enable;
  "window.commandCenter" = true;
  "workbench.colorTheme" = "Catppuccin Macchiato"; # "Lambda Dark+";
  # Catppuccin recommended settings
  "editor.semanticHighlighting.enabled" = true;
  "terminal.integrated.minimumContrastRatio" = 1;
  "window.titleBarStyle" = "custom";
  "gopls.ui.semanticTokens" = true;
  "workbench.iconTheme" = "catppuccin-macchiato";
  # End Catppuccin settings
  "workbench.editorAssociations" = {
    "*.pdf" = "latex-workshop-pdf-hook";
  };
}
