{ lib, pkgs, ... }:
let
  limaWithGuests = pkgs.lima.override {
    withAdditionalGuestAgents = true; # for emulating non-native architectures
  };
in
{
  home.packages =
    (with pkgs; [
      ## Containers
      docker
      docker-compose
      podman
      podman-compose
      (colima.override {
        lima = limaWithGuests;
      })

      act # GH Actions locally
      ctop # Monitor containers

      ## K8s
      minikube
      kind
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

      # ansible
      # vagrant
      limaWithGuests

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
        tart # VMs (Apple hypervisor framework)
        softnet # VM networking for tart
        orchard # VM orchestrator for macOS clusters
      ]
    )
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.nerdctl ];

  programs.k9s.enable = true;
}
