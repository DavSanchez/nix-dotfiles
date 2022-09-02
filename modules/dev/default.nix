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
    podman-tui
    podman-compose
    minikube
    kubectl
    kubernetes-helm
    k9s
    # kubeval # FIXME fails to build on mac for some reason
    kubescape
    kube-score
    # kompose # FIXME fails to build on mac for some reason
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
