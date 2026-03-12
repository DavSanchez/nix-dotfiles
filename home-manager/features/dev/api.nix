{ pkgs, ... }:
{
  ## Other packages
  home.packages = (
    with pkgs;
    [
      # Testing APIs
      openapi-tui
      openapi-generator-cli
      prism-cli
    ]
  );
}
