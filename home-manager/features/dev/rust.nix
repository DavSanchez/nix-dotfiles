{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      rustup

      cargo-zigbuild # cross-compilation via zig
      zig # needed by cargo-zigbuild
      cargo-cache
      cargo-nextest
      bacon # background rust code checker
    ];
  };
}
