{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      ## Containers
      docker

      act # GH Actions locally
      ctop # Monitor containers

      ## K8s
      minikube
      kubectl
      kubernetes-helm
      kops
      k9s
      kubescape
      kube-score
      kubeval
      kompose
      stern
      kubeshark

      localstack
      ansible

      ## Terraform
      terraform
      terraform-ls # Langserver
      terraformer
      terrascan
      # terragrunt
      # terraform-rover

      ## NixOps
      # nixops
      # nixops-dns
      # morph
      colmena

      # Monitoring
      # netdata # broken
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ## Container runtimes on macOS
      colima
    ] ++ lib.optionals pkgs.stdenv.isLinux [
      podman
      podman-tui
      podman-compose

      nixops_unstable
    ];
}
