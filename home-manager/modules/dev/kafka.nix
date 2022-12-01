{pkgs, ...}: {
  home.packages = with pkgs; [
    apacheKafka
    kcat
    kaf
    # kcctl
    # kaskade
    # confluent-platform
  ];
}
