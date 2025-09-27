{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.go = {
    enable = true;
    env.GOPATH = builtins.toString (lib.path.append (/. + config.home.homeDirectory) ".go");
  };

  home.packages = with pkgs; [
    gopls # Langserver
    delve
    gotools
    gomodifytags
    impl
    go-tools
    gotests
    golangci-lint
  ];
}
