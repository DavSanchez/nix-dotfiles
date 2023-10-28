{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      ## Containers
      docker
      docker-compose
      podman
      podman-compose

      act # GH Actions locally
      ctop # Monitor containers

      ## K8s
      minikube
      kubectl
      kubernetes-helm
      kops
      # kubescape
      kube-score
      kubeval
      kompose
      stern
      kubeshark

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
      # nixops_unstable
      # nixops-dns
      # morph
      colmena

      # Monitoring
      # netdata # broken
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ## Container runtimes on macOS
      colima
    ];

  programs = {
    k9s = {
      enable = true;
    };
  };
}
