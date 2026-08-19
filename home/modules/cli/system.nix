{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      procs
      fastfetch
      kontroll
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      kmon
    ];

  programs = {
    noti = {
      enable = true;
      # settings = { };
    };
    topgrade = {
      enable = true;
      # settings = { };
    };
    bottom.enable = true;
  };
}
