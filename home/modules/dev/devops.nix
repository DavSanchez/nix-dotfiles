{ lib, pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      ## Containers
      docker
      docker-compose
      # podman
      # podman-compose

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
      tilt

      # ansible
      # vagrant
      qemu_full
      lima-full

      ## Terraform
      # terraform
      # terraform-ls # Langserver
      opentofu # Terraform alternative
      # terraformer
      # terrascan
      # terragrunt
      # terraform-rover

      ## NixOps
      # nixops-dns
      # morph
      deploy-rs
      colmena
      nixos-anywhere

      # Monitoring
      # netdata # broken

      process-compose

      shellcheck # always shell scripts
    ])
    ++ lib.optionals pkgs.stdenv.isDarwin (
      with pkgs;
      [
        colima
        container
      ]
    )
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.nerdctl ];

  programs.k9s.enable = true;
}
