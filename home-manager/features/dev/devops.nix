{ lib, pkgs, ... }:
{
  home.packages =
    (with pkgs; [
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
      helm-docs
      kops
      # kubescape
      # kube-score
      # kubeval
      # kompose
      stern
      kubeshark

      ansible
      vagrant

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
      # deploy-rs
      colmena

      # Monitoring
      # netdata # broken

      # cirrus-cli # Related to tart/orchard
      process-compose
    ])
    ++ lib.optionals pkgs.stdenv.isDarwin (
      with pkgs;
      [
        ## Container runtimes on macOS
        colima # Containers
        tart # VMs (Apple hypervisor framework)
        softnet # VM networking for tart
        orchard # VM orchestrator for macOS clusters
      ]
    )
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.nerdctl ];

  programs.k9s.enable = true;
}
