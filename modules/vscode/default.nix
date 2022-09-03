{ ... }:

{
  import = ./package.nix;

  home.editors.vscode = {
    enable = true;
    mutable = true;
  };
}