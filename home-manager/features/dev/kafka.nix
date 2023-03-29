{pkgs, ...}: {
  home.packages = with pkgs; [
    kcat
    kaf
    kcctl
    # kaskade
    avro-tools
    apacheKafka
  ];
}
