{
  pkgs,
  config,
  lib,
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
  programs.vscode.profiles.default.userSettings = {
    "breadcrumbs.enabled" = true;
    "debug.allowBreakpointsEverywhere" = true;
    "diffEditor.ignoreTrimWhitespace" = false;
    "editor.accessibilitySupport" = "off";
    "editor.bracketPairColorization.enabled" = true;
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.fontFamily" = "'Iosevka Slab', FiraCode, Menlo, Monaco, 'Courier New', monospace";
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
    "github.copilot.nextEditSuggestions.enabled" = true;
    "haskell.plugin.semanticTokens.globalOn" = true;
    "haskell.manageHLS" = "PATH";
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
    "nix.serverSettings" = {
      "nixd.formatting.command" = [ "${pkgs.nixfmt}/bin/nixfmt" ];
    };
    "nix.formatterPath" = "nixfmt";
    "rust-analyzer.check.command" = "clippy";
    "search.exclude" = {
      "**/.direnv" = true;
    };
    "terminal.external.osxExec" = "Ghostty.app";
    "terminal.integrated.fontFamily" =
      "'Iosevka Term Slab', FiraCode, Menlo, Monaco, 'Courier New', monospace";
    "terminal.integrated.fontSize" = 14;
    "terminal.integrated.fontLigatures.enabled" = true;
    "terminal.integrated.scrollback" = 5000;
    "terminal.integrated.shellIntegration.enabled" = true;
    # "vim.enableNeovim" = true; # programs.neovim.enable;
    # "vim.neovimUseConfigFile" = true; # programs.neovim.enable;
    "window.commandCenter" = true;
    # Catppuccin recommended settings
    # Others are delegated to the catppuccin flake
    "workbench.iconTheme" = "catppuccin-mocha";
    # End Catppuccin settings
    "workbench.editor.wrapTabs" = true;
    "workbench.editorAssociations" = {
      "*.pdf" = "latex-workshop-pdf-hook";
    };
    "[dockercompose]" = {
      "editor.insertSpaces" = true;
      "editor.tabSize" = 2;
      "editor.autoIndent" = "advanced";
      "editor.defaultFormatter" = "redhat.vscode-yaml";
    };
    "[github-actions-workflow]" = {
      "editor.defaultFormatter" = "redhat.vscode-yaml";
    };
    "chat.disableAIFeatures" = true; # I will use whatever provider
    "claudeCode.preferredLocation" = "panel";
    "acp.providers" = {
      "hermes" = {
        "command" = "hermes-acp";
        "args" = [ ];
        "displayName" = "Hermes Agent";
      };
    };
    "acp.defaultProvider" = "hermes";
  }
  // lib.optionalAttrs (config.programs.nushell.enable && config.programs.fish.enable) {
    "terminal.integrated.defaultProfile.linux" = "nu";
    "terminal.integrated.defaultProfile.osx" = "nu";
    "terminal.integrated.profiles.linux" = {
      "nu" = {
        path = "${nu-bootstrap}/bin/nu-bootstrap";
      };
    };
    "terminal.integrated.profiles.osx" = {
      "nu" = {
        path = "${nu-bootstrap}/bin/nu-bootstrap";
      };
    };
  };
}
