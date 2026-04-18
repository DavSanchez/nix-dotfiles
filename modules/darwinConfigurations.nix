{ inputs, ... }:
{
  flake.darwinConfigurations = {
    sierpe = inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ../hosts/darwin/sierpe.nix
      ];
    };
    solio = inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs;
      };
      modules = [ ../hosts/darwin/solio.nix ];
    };
  };
}
