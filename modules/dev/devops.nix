{ lib, ... }:
{
  home.packages = with pkgs; [
    ## Containers
    podman
    podman-tui
    podman-compose
    lazydocker
    ctop

    ## K8s
    minikube
    kubectl
    kubernetes-helm
    k9s
    kubescape
    kube-score
    # kubeval # FIXME fails to build on mac for some reason
    # kompose # FIXME fails to build on mac for some reason

    ## AWS
    awscli2

    ## Terraform
    terraform
    terrascan
    # terraform-rover

    ## NixOps
    nixops_unstable
    # nixops
    # nixops-dns
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    ## Container runtimes on macOS
    colima
  ];
}
