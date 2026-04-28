{ pkgs, ... }:
{
  programs.vscode.profiles.default = {
    # Extension issues and other documentation:
    # <https://nixos.wiki/wiki/VSCodium>
    enableExtensionUpdateCheck = false;
    extensions =
      (with pkgs.vscode-extensions; [
        ## Extensions present in nixpkgs
        # anthropic.claude-code
        arrterian.nix-env-selector
        banacorn.agda-mode
        # betterthantomorrow.calva
        # catppuccin.catppuccin-vsc # Delegated to catppuccin flake
        # catppuccin.catppuccin-vsc-icons # Delegated to catppuccin flake
        christian-kohler.path-intellisense
        davidanson.vscode-markdownlint
        # dbaeumer.vscode-eslint
        # dhall.dhall-lang
        # dhall.vscode-dhall-lsp-server
        editorconfig.editorconfig
        elixir-lsp.vscode-elixir-ls
        golang.go
        gruntfuggly.todo-tree
        haskell.haskell
        # james-yu.latex-workshop
        jnoortheen.nix-ide
        justusadam.language-haskell
        leanprover.lean4
        llvm-vs-code-extensions.vscode-clangd
        # markis.code-coverage # FIXME
        mkhl.direnv
        ms-kubernetes-tools.vscode-kubernetes-tools
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-containers
        ms-vscode.hexeditor
        # ms-vscode.makefile-tools
        ms-vsliveshare.vsliveshare
        mshr-h.veriloghdl
        # mvllow.rose-pine
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        skellock.just
        tamasfe.even-better-toml
        thenuprojectcontributors.vscode-nushell-lang
        timonwong.shellcheck
        usernamehw.errorlens
        vadimcn.vscode-lldb
        valentjn.vscode-ltex
        # vscode-icons-team.vscode-icons
        ziglang.vscode-zig
      ])
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "disableligatures";
          publisher = "CoenraadS";
          version = "0.0.10";
          sha256 = "090wg4lin4y06nhg45p9mjsqwfa21bdgafj57swh5z6fpv3pqxx2";
        }
        {
          name = "dance";
          publisher = "gregoire";
          version = "0.5.16000"; # pre-release
          sha256 = "sha256-du4Sz5rlKaAy5LXf7RfCt6iUSOAMMshlvewzcn4sCCk=";
        }
        {
          name = "dance-helix"; # Depends on `gregoire.dance` pre-release above
          publisher = "gregoire";
          version = "0.1.1001";
          sha256 = "sha256-wWOlBsOJEQ8rjN3yMsegYg/8t3Jy6Gz/RyCn4/Ts7ZE=";
        }
        # {
        #   name = "nix-embedded-highlighter";
        #   publisher = "atomicspirit";
        #   version = "0.0.1";
        #   sha256 = "sha256-KZfUaPjReHQH0XCCiejAs+0Go8WEeGiOuxjkTfSnku0=";
        # }
        {
          name = "wavetrace";
          publisher = "wavetrace";
          version = "1.1.2";
          sha256 = "11k57vppx5i7i56kgp4b2r97g6fqmvm7x0mzf8zj5r42ipn070zg";
        }
      ];
  };
}
