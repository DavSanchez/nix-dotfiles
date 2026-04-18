{ inputs, ... }:
{
  flake.nixosConfigurations = {
    blackbee = inputs.nixos-raspberrypi.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ../hosts/blackbee/configuration.nix
      ];
    };
    eter = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ../hosts/eter/configuration.nix
      ];
    };
  };
}
