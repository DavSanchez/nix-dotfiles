{ inputs, ... }:
{
  flake.overlays = import ../overlays { inherit inputs; };
}
