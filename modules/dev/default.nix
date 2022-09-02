{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Shell
    shellcheck

    # C
    gcc
    llvm

    # Clojure
    clojure

    # .NET
    dotnet-sdk

    # DevOps
    podman
    colima
    minikube
    kubectl
    helm
    k9s
    kompose
    terraform
    awscli2
    # terraform-rover
    # nixops
    # nixops-dns
    nixops_unstable

    kcat
    apacheKafka
  ];

  imports = [
    ./haskell.nix
    ./rust.nix
    ./go.nix
  ];
}
