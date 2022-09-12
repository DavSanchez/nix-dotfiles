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

    elixir

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
    kaf
    # confluent-platform

    yosys
    verilator
    zig

    exercism

    bazelisk
    bazel-buildtools

    unison-ucm
    python3
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    colima
  ];

  imports = [
    ./haskell
    ./rust.nix
    ./go.nix
    # ./java.nix
  ];
}
