{ ... }:
{
  home.packages = with pkgs; [
    apacheKafka
    kcat
    kaf
    kaskade
    # confluent-platform
  ];
}
