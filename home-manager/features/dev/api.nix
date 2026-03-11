{ pkgs, ... }:
{
  ## Other packages
  home.packages = (
    with pkgs;
    [
      # Testing APIs
      bruno
      bruno-cli
      hoppscotch

      openapi-tui
      openapi-generator-cli
    ]
  );
}
