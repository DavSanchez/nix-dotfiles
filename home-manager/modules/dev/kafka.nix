{pkgs, ...}: {
  home.packages = with pkgs; [
    kcat
    kaf
    kcctl
    # kaskade
    confluent-cli
    confluent-platform
    avro-tools
  ];
}
