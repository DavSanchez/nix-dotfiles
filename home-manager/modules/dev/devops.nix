{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      ## Containers
      ctop # Docker only?

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

      localstack

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
    ] ++ lib.optionals pkgs.stdenv.isLinux [
      podman
      podman-tui
      podman-compose
    ];
}
