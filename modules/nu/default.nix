{
  programs.nushell = {
    enable = true;
  };
  home.file = {
    "Library/Application Support/nushell/env.nu".source =
      lib.optional std.isDarwin ./env.nu;
    "Library/Application Support/nushell/config.nu".source =
      lib.optional std.isDarwin ./config.nu;
    ".config/nushell/env.nu".source =
      lib.optional std.isLinux ./env.nu;
    ".config/nushell/config.nu".source =
      lib.optional std.isLinux ./config.nu;
  };
}
