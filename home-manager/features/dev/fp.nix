{ pkgs, ... }:
{
  home.packages = with pkgs; [
    idris2 # FP with dependent types, compiles to C
    # idris2Packages.idris2Lsp # Langserver

    # agda # FP with dependent types, compiles to Haskell
    # haskellPackages.agda-language-server # Langserver

    elixir # Dynamic FP for the Erlang VM
    elixir-ls # Langserver

    # dotnet-sdk # For F-sharp: FP for .NET
    # fstar # ML-like FP language aimed at program verification
    elmPackages.elm # FP for the frontend

    purescript # FP for the frontend
    # nodePackages.purescript-language-server # Langserver (unmaintained)

    clojure # FP for the JVM, lisp-like
    clojure-lsp # Langserver

    elan # Lean theorem prover version manager, FP with dependent types

    flix # FP for the JVM
    # roc.cli # Roc programming lang, comes from an overlay
    # grain # FP for the web
    unison-ucm # distributed, content-addressed FP
  ];
}
