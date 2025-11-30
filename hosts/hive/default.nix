{
  nixpkgs,
  inputs,
  ...
}:
{
  meta = {
    nixpkgs = import nixpkgs {
      # Change it to the arch-os you are using locally
      system = "aarch64-darwin";
    };
    specialArgs = {
      inherit inputs;
    };
    nodeNixpkgs = {
      foundry-pi = import inputs.nixpkgs { system = "aarch64-linux"; };
      eter = import inputs.nixpkgs { system = "x86_64-linux"; };
    };
  };
  # nixberrypi = ./nixberrypi/configuration.nix;
  foundry-pi = ./foundry-pi/configuration.nix;
  eter = ./eter/configuration.nix;
}
