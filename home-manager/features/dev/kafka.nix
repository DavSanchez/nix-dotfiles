{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kcat
    kaf
    kafkactl
    apacheKafka
  ];
}
