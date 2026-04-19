{ pkgs, ... }:
{
  programs.awscli.enable = true;
  home.packages = with pkgs; [ ssm-session-manager-plugin ];

  # home.file.".aws/config".source = ../../.secrets/aws_config;
}
