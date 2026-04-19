{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      rustup

      # debugging
      lldb

      cargo-zigbuild # cross-compilation via zig
      zig # needed by cargo-zigbuild
      zls # just go with everything
      
      cargo-cache
      cargo-nextest
      bacon # background rust code checker
    ];
  };
}
