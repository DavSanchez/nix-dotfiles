{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # C
    gcc

    # Clojure
    clojure

    # docker
    # docker

    # go
    go
    # golangci-lint
  ];
}
