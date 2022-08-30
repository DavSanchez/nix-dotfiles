{
  simple = {
    path = ./simple;
    description = "A simple template";
  };
  c = {
    description = "C/C++ environment (clang)";
    path = ./c;
  };
  document = {
    description = "Document building environment (pandoc)";
    path = ./document;
  };
  haskell = {
    description = "Haskell environment (cabal)";
    path = ./haskell;
  };
  rust = {
    description = "Rust environment (cargo)";
    path = ./rust;
  };
}
