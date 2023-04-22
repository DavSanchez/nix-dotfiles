{pkgs, ...}: {
  home.packages = with pkgs; [
    vale
    ## Typesetting (with pygments for minted, pygmentex...)
    texlive.combined.scheme-full
    typst
    python311Packages.pygments
    haskellPackages.pandoc-crossref
  ];

  programs = {
    pandoc.enable = true;

    papis.enable = true;
  };
}
