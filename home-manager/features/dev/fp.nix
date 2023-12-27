{pkgs, ...}: {
  home.packages = with pkgs; [
    idris2 # Functional programming with dependent types
    agda # Functional programmingw with dependent types, 2
    elixir # Functional programming for the Erlang VM
    dotnet-sdk # For F-sharp: functional programming for .NET
    fstar # ML-like functional programming language aimed at program verification
    elmPackages.elm # Functional programming for the frontend
    flix # Functional programming for the JVM
    clojure # Functional programming for the JVM, lisp-like
    roc.cli # Roc programming lang, it's an overlay
    unison-ucm # ... and more
  ];
}
