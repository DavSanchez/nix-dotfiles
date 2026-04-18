{ inputs, withSystem, ... }:
{
  flake.homeConfigurations = withSystem "aarch64-darwin" (
    { pkgs, ... }:
    {
      "david@sierpe" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [ ../home-manager/sierpe.nix ];
      };
      "david@solio" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [ ../home-manager/solio.nix ];
      };
      "davidsanchez@nr" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [ ../home-manager/home-nr.nix ];
      };
    }
  );
}
