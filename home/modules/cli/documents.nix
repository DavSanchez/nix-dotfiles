{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vale
    typst
    ltex-ls-plus # Language server for the LTeX+ VSCode extension
  ];

  programs = {
    pandoc.enable = true;
    # papis.enable = true;
  };
}
