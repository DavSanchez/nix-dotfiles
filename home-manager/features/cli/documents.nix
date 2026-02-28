{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vale
    ## Typesetting (with pygments for minted, pygmentex...)
    # texlive.combined.scheme-full
    typst
  ];

  programs = {
    pandoc.enable = true;
    # papis.enable = true;
  };
}
