{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vale
    typst
  ];

  programs = {
    pandoc.enable = true;
    # papis.enable = true;
  };
}
