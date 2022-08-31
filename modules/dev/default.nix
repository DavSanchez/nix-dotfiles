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
    nixops
    nixops-with-plugins


    # go
    go
    # golangci-lint
  ];

  imports = [
    ./haskell.nix
    ./rust.nix
  ];
}
