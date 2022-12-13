{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
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
      kubeval
      kompose
      stern

      ## AWS
      awscli2
      ssm-session-manager-plugin

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
      morph
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ## Container runtimes on macOS
      colima
    ];
}
