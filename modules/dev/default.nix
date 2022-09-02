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
  ];

  imports = [
    ./haskell.nix
    ./rust.nix
    ./go.nix
  ];
}
