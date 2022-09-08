{ pkgs, ... }:

{
  programs.nushell = {
    enable = true;
  };
  home.file = { }
    // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin
    {
      "Library/Application Support/nushell/env.nu".source = ./env.nu;
      "Library/Application Support/nushell/config.nu".source = ./config.nu;
    }
    // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux
    {
      ".config/nushell/env.nu".source = ./env.nu;
      ".config/nushell/config.nu".source = ./config.nu;
    };
}
