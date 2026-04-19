{ pkgs, ... }:
{
  ## Other packages
  home.packages = (
    with pkgs;
    [
      # Testing APIs
      openapi-tui
      prism-cli
    ]
  );
}
