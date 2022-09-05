{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Shell
    shellcheck

    # C
    gcc
    llvm
    cling
    cmake
    # conan

    # Clojure
    clojure
    leiningen

    # .NET
    dotnet-sdk

    # DevOps
    podman
    podman-tui
    podman-compose
    lazydocker
    minikube
    kubectl
    kubernetes-helm
    k9s
    # kubeval # FIXME fails to build on mac for some reason
    kubescape
    kube-score
    # kompose # FIXME fails to build on mac for some reason
    ctop
    terraform
    terrascan
    awscli2
    # terraform-rover
    # nixops
    # nixops-dns
    nixops_unstable

    kcat
    apacheKafka

    yosys
    verilator
    zig

    exercism

    bazelisk
    bazel-buildtools

    unison-ucm
    python3
  ];

  imports = [
    ./haskell.nix
    ./rust.nix
    ./go.nix
  ];
}
