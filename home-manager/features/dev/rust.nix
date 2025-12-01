{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      rustup

      trunk # WASM bundler
      cargo-watch # Watch for changes and run cargo-watch
      cargo-zigbuild # cross-compilation via zig
      cargo-cache
    ];
  };
}
