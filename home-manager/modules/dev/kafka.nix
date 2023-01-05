{pkgs, ...}: {
  home.packages = with pkgs; [
    kcat
    kaf
    kcctl
    # kaskade
  ];
}
