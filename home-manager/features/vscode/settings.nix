pkgs: {
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
    "'Iosevka Slab Custom', 'FiraCode Nerd Font', Menlo, Monaco, 'Courier New', monospace";
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
  "git.blame.editorDecoration.enabled" = true;
  "git.defaultBranchName" = "master";
  "haskell.plugin.semanticTokens.globalOn" = true;
  "haskell.manageHLS" = "PATH";
  "nix.enableLanguageServer" = true;
  "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
  "nix.serverSettings" = {
    "nixd.formatting.command" = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
  };
  "nix.formatterPath" = "nixfmt";
  "rust-analyzer.check.command" = "clippy";
  "search.exclude" = {
    "**/.direnv" = true;
  };
  "terminal.external.osxExec" = "Ghostty.app";
  "terminal.integrated.defaultProfile.linux" = "fish";
  "terminal.integrated.defaultProfile.osx" = "fish";
  "terminal.integrated.fontFamily" = "'Iosevka Term Slab Custom'";
  "terminal.integrated.fontSize" = 14;
  "terminal.integrated.fontLigatures.enabled" = true;
  "terminal.integrated.scrollback" = 5000;
  "terminal.integrated.shellIntegration.enabled" = true;
  "vim.enableNeovim" = true; # programs.neovim.enable;
  "vim.neovimUseConfigFile" = true; # programs.neovim.enable;
  "window.commandCenter" = true;
  # Catppuccin recommended settings
  # Others are delegated to the catppuccin flake
  "workbench.iconTheme" = "catppuccin-mocha";
  # End Catppuccin settings
  "workbench.editorAssociations" = {
    "*.pdf" = "latex-workshop-pdf-hook";
  };
}
