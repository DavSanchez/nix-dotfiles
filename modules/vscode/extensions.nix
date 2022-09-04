{ pkgs, ... }:
let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;

  # Helper function to cut down on boilerplate
  extension = { publisher, name, version, sha256 }:
    buildVscodeMarketplaceExtension {
      mktplcRef = { inherit name publisher sha256 version; };
    };
in
with pkgs.vscode-extensions; [
      # aaron-bond.better-comments@3.0.2
      arrterian.nix-env-selector
      betterthantomorrow.calva
      bungcip.better-toml
      christian-kohler.path-intellisense
      # CoenraadS.disableligatures@0.0.10
      # cschlosser.doxdocgen@1.4.0
      DavidAnson.vscode-markdownlint
      dbaeumer.vscode-eslint
      dhall.dhall-lang
      dhall.vscode-dhall-lsp-server
      eamodio.gitlens
      esbenp.prettier-vscode
      golang.go@
      # gvekony.systemverilog-1800-2012@1.0.27
      hashicorp.terraform
      haskell.haskell
      # Ionide.Ionide-fsharp
      JakeBecker.elixir-ls
      James-Yu.latex-workshop
      # jamesottaway.nix-develop@0.0.1
      # jeff-hykin.better-cpp-syntax@1.15.19
      # jeppeandersen.vscode-kafka@0.15.0
      jnoortheen.nix-ide
      justusadam.language-haskell
      ## liviuschera.noctis@10.40.0
      llvm-vs-code-extensions.vscode-clangd
      # mkhl.direnv@0.6.1
      ms-azuretools.vscode-docker
      # ms-dotnettools.csharp@1.25.0
      # ms-dotnettools.dotnet-interactive-vscode@1.0.3452020
      # ms-dotnettools.vscode-dotnet-pack@1.0.9
      ms-kubernetes-tools.vscode-kubernetes-tools
      # ms-ossdata.vscode-postgresql@0.3.0
      ms-python.python
      ms-python.vscode-pylance
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      # ms-vscode-remote.remote-containers@0.251.0
      ms-vscode-remote.remote-ssh
      # ms-vscode-remote.remote-ssh-edit@0.80.0
      # ms-vscode-remote.remote-wsl@0.66.3
      # ms-vscode.cmake-tools@1.12.26
      ms-vscode.cpptools
      # ms-vscode.cpptools-extension-pack@1.3.0
      # ms-vscode.cpptools-themes@1.0.0
      # ms-vscode.hexeditor@1.9.8
      # ms-vscode.makefile-tools@0.6.0
      # mshr-h.veriloghdl@1.5.4
      # nwolverson.ide-purescript@0.25.12
      # nwolverson.language-purescript@0.2.8
      # PenumbraTheme.penumbra@0.4.0
      # pinage404.nix-extension-pack@2.0.0
      # platformio.platformio-ide@2.5.4
      # redhat.vscode-xml@0.21.2022062916
      # redhat.vscode-yaml@1.10.1
      rust-lang.rust-analyzer
      # s0kil.vscode-hsx@0.4.0
      scala-lang.scala
      scalameta.metals
      svelte.svelte-vscode
      # tidalcycles.vscode-tidalcycles@1.4.1
      tomoki1207.pdf
      # twxs.cmake@0.0.17
      usernamehw.errorlens
      valentjn.vscode-ltex
      # visortelle.haskell-spotlight@0.0.3
      # vscode-icons-team.vscode-icons@11.16.0
      # wavetrace.wavetrace@1.1.2
      zxh404.vscode-proto3

      # # * This creates a derivation for a VSCode Marketplace extension (useful!)
      (extension {
        publisher = "BazelBuild";
        name = "vscode-bazel";
        version = "0.5.0";
        sha256 = "sha256-JJQSwU3B5C2exENdNsWEcxFSgWHnImYas4t/KLsgTj4=";
      })
    ]
