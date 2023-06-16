{pkgs, ...}: {
  home.packages = with pkgs; [
    procs
    neofetch
    diskonaut
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
