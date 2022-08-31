{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # C
    gcc

    # Clojure
    clojure

    # DevOps
    podman
    colima
    minikube
    # nixops
    # nixops-dns
    nixops_unstable


    # go
    go
    # golangci-lint
  ];

  imports = [
    ./haskell.nix
    ./rust.nix
  ];
}
