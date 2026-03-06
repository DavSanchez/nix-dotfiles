{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      procs
      fastfetch
      kontroll
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      kmon
      uutils-uutils-procps
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
