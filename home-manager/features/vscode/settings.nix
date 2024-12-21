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
  zellij-script = pkgs.writeShellScript "vscode-zellij" ''
    if ${pkgs.zellij}/bin/zellij ls -n |& grep -E "^$1 .*EXITED" >/dev/null; then
      ${pkgs.zellij}/bin/zellij delete-session "$1" # delete dead session
    fi
    if ${pkgs.zellij}/bin/zellij ls -n |& grep -E "^$1 " >/dev/null; then
      ${pkgs.zellij}/bin/zellij attach "$1"
    else
      # We don't have a session with this name yet
      ${pkgs.zellij}/bin/zellij --session "$1" --new-session-with-layout=compact options --no-pane-frames --simplified-ui=true ${pkgs.lib.optionalString pkgs.stdenv.isDarwin "--copy-command=pbcopy"}
    fi
  '';
  zellij-shell-profile = {
    "path" = "${zellij-script}";
    "args" = [
      "vscode:\${workspaceFolderBasename}"
    ];
  };
  term-profiles = {
    "tmux" = tmux-shell-profile;
    "zellij" = zellij-shell-profile;
  };
in
{
  "breadcrumbs.enabled" = true;
  "dance.modes" = {
    "" = {
      "hiddenSelectionsIndicatorsDecoration" = {
        "after" = {
          "color" = "$inputValidation.infoForeground";
        };
        "backgroundColor" = "$inputValidation.infoBackground";
        "borderColor" = "$inputValidation.infoBorder";
      };
    };
  };
  "diffEditor.ignoreTrimWhitespace" = false;
  "editor.accessibilitySupport" = "off";
  "editor.bracketPairColorization.enabled" = true;
  "editor.cursorSmoothCaretAnimation" = "on";
  "editor.fontFamily" =
    "'Iosevka Custom', 'FiraCode Nerd Font', Menlo, Monaco, 'Courier New', monospace";
  "editor.fontSize" = 14;
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
  "editor.stickyScroll.enabled" = false;
  "editor.tabSize" = 2;
  "editor.wordWrap" = "on";
  "files.associations" = {
    "*.tidal" = "haskell";
  };
  "files.autoSave" = "afterDelay";
  "git.autofetch" = true;
  "git.defaultBranchName" = "master";
  "nix.enableLanguageServer" = true;
  "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
  "nix.serverSettings" = {
    "nixd.formatting.command" = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
  };
  "nix.formatterPath" = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
  "rust-analyzer.check.command" = "clippy";
  "search.exclude" = {
    "**/.direnv" = true;
  };
  "terminal.external.osxExec" = "WezTerm.app";
  "terminal.integrated.fontFamily" = "'Iosevka Term Custom'";
  "terminal.integrated.fontSize" = 14;
  "terminal.integrated.fontLigatures" = true;
  "terminal.integrated.scrollback" = 5000;
  "terminal.integrated.shellIntegration.enabled" = true;
  "terminal.integrated.profiles.linux" = term-profiles;
  "terminal.integrated.profiles.osx" = term-profiles;
  "terminal.integrated.defaultProfile.linux" = "zellij";
  "terminal.integrated.defaultProfile.osx" = "zellij";
  "vim.enableNeovim" = true; # programs.neovim.enable;
  "vim.neovimUseConfigFile" = true; # programs.neovim.enable;
  "window.commandCenter" = true;
  "workbench.colorTheme" = "Catppuccin Mocha"; # "Lambda Dark+";
  # Catppuccin recommended settings
  "editor.semanticHighlighting.enabled" = true;
  "terminal.integrated.minimumContrastRatio" = 1;
  "window.titleBarStyle" = "custom";
  "workbench.iconTheme" = "catppuccin-mocha";
  # End Catppuccin settings
  "workbench.editorAssociations" = {
    "*.pdf" = "latex-workshop-pdf-hook";
  };
}
