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
      # kube-score
      # kubeval
      # kompose
      stern
      kubeshark

      ansible

      ## Terraform
      # terraform
      # terraform-ls # Langserver
      opentofu # Terraform alternative
      # terraformer
      # terrascan
      # terragrunt
      # terraform-rover

      ## NixOps
      # nixops-dns
      # morph
      colmena
      deploy-rs

      # Monitoring
      # netdata # broken
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ## Container runtimes on macOS
      colima # Containers
      tart # VMs
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      nerdctl
    ];

  programs = {
    k9s = {
      enable = true;
    };
  };
}
