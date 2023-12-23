{pkgs, ...}: {
  home.packages = with pkgs; [
    idris2 # Functional programming with dependent types
    agda # Functional programmingw with dependent types, 2
    elixir # Functional programming for the Erlang VM
    dotnet-sdk # For F-sharp: functional programming for .NET
    elmPackages.elm # Functional programming for the frontend
    flix # Functional programming for the JVM
    # rocPkgs.cli # Roc programming lang, it's an overlay
    unison-ucm # ... and more
  ];
}
