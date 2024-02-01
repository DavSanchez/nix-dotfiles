{pkgs, ...}: {
  home.packages = with pkgs; [
    idris2 # FP with dependent types, compiles to C
    agda # FP with dependent types, compiles to Haskell
    elixir # Dynamic FP for the Erlang VM
    gleam # Statically typed FP for the Erlang VM
    dotnet-sdk # For F-sharp: FP for .NET
    fstar # ML-like FP language aimed at program verification
    elmPackages.elm # FP for the frontend
    purescript # FP for the frontend
    clojure # FP for the JVM, lisp-like
    flix # FP for the JVM
    roc.cli # Roc programming lang, comes from an overlay
    grain # FP for the web
    unison-ucm # distributed, content-addressed FP
  ];
}
