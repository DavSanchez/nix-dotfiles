{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # C
    gcc

    # Clojure
    clojure

    # docker
    podman
    colima
    minikube

    # go
    go
    # golangci-lint
  ];

  imports = [
    ./haskell.nix
    ./rust.nix
  ];
}
