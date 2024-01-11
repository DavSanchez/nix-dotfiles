{pkgs, ...}: {
  home.packages = with pkgs; [
    procs
    neofetch
    diskonaut
  ] ++ lib.optionals pkgs.stdenv.isLinux [
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
