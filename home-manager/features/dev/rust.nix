{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      rustup
      rust-analyzer # Langserver
      trunk # WASM bundler
      cargo-watch # Watch for changes and run cargo-watch
      cargo-cross
    ];
  };
}
