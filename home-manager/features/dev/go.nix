{ pkgs, ... }:
{
  programs.go = {
    enable = true;
    goPath = ".go";
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
