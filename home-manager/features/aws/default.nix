{pkgs, ...}: {
  home.packages = with pkgs; [
    awscli2
    ssm-session-manager-plugin
  ];

  # home.file.".aws/config".source = ../../.secrets/aws_config;
}
