{
  "[haskell]"."editor.defaultFormatter" = "haskell.haskell";
  "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
  "[python]"."editor.formatOnType" = true;
  "[svelte]"."editor.defaultFormatter" = "svelte.svelte-vscode";
  "breadcrumbs.enabled" = true;
  "calva.paredit.defaultKeyMap" = "strict";
  "clangd.checkUpdates" = true;
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
  "files.exclude" = {
    "**/.classpath" = true;
    "**/.factorypath" = true;
    "**/.project" = true;
    "**/.settings" = true;
  };
  "files.watcherExclude" = {
    "**/.ammonite" = true;
    "**/.bloop" = true;
    "**/.metals" = true;
  };
  "git.autofetch" = true;
  "go.lintTool" = "golangci-lint";
  "go.toolsManagement.autoUpdate" = true;
  "haskell.manageHLS" = "PATH";
  "haskell.plugin.eval.config.exception" = true;
  "hexeditor.columnWidth" = 16;
  "hexeditor.defaultEndianness" = "little";
  "hexeditor.inspectorType" = "aside";
  "hexeditor.showDecodedText" = true;
  "latex-workshop.latex.autoClean.run" = "onBuilt";
  "latex-workshop.latex.clean.fileTypes" = [
    "*.aux"
    "*.bbl"
    "*.blg"
    "*.idx"
    "*.ind"
    "*.lof"
    "*.lot"
    "*.out"
    "*.toc"
    "*.acn"
    "*.acr"
    "*.alg"
    "*.glg"
    "*.glo"
    "*.gls"
    "*.ist"
    "*.fls"
    "*.log"
    "*.fdb_latexmk"
    "*.run.xml"
    "*.synctex.gz"
    "_minted-*"
    "*.bcf"
  ];
  "latex-workshop.latex.tools" = [
    {
      "args" = [
        "-synctex=1"
        "-interaction=nonstopmode"
        "--shell-escape"
        "-file-line-error"
        "-pdf"
        "%DOC%"
      ];
      "command" = "latexmk";
      "name" = "latexmk";
    }
  ];
  "latex-workshop.linting.chktex.enabled" = true;
  "latex-workshop.view.pdf.viewer" = "tab";
  "nix.enableLanguageServer" = true;
  "nix.serverPath" = "nil";
  "nix.formatterPath" = "alejandra";
  "platformio-ide.activateOnlyOnPlatformIOProject" = true;
  "python.languageServer" = "Pylance";
  "redhat.telemetry.enabled" = false;
  "svelte.enable-ts-plugin" = true;
  "terminal.external.osxExec" = "WezTerm.app";
  "terminal.integrated.fontFamily" = "'FiraCode Nerd Font Mono'";
  "terminal.integrated.scrollback" = 5000;
  "terminal.integrated.shellIntegration.enabled" = true;
  "terraform.codelens.referenceCount" = true;
  "todo-tree.regex.regex" = "(//|#|<!--|;|/\\*|--|\\{-|^|^[ \\t]*(-|\\d+.))\\s*($TAGS)";
  "verilog.linting.linter" = "verilator";
  "window.commandCenter" = true;
  "workbench.colorTheme" = "Lambda Dark+"; # previous: "Catppuccin Mocha";
  "workbench.editorAssociations" = {
    "*.pdf" = "latex-workshop-pdf-hook";
  };
  "workbench.iconTheme" = "material-icon-theme";
  "workbench.productIconTheme" = "material-product-icons";
  
  # This is introduced by the AWS extension to support CloudFormation YAML
  "yaml.customTags" = [
    "!And"
    "!And sequence"
    "!If"
    "!If sequence"
    "!Not"
    "!Not sequence"
    "!Equals"
    "!Equals sequence"
    "!Or"
    "!Or sequence"
    "!FindInMap"
    "!FindInMap sequence"
    "!Base64"
    "!Join"
    "!Join sequence"
    "!Cidr"
    "!Ref"
    "!Sub"
    "!Sub sequence"
    "!GetAtt"
    "!GetAZs"
    "!ImportValue"
    "!ImportValue sequence"
    "!Select"
    "!Select sequence"
    "!Split"
    "!Split sequence"
  ];
  "vim.enableNeovim" = true; # programs.neovim.enable;
  "vim.neovimUseConfigFile" = true; # programs.neovim.enable;
}
