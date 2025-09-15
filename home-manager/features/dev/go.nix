{ pkgs, ... }:
{
  programs.go = {
    enable = true;
    env.GOPATH = ".go";
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
