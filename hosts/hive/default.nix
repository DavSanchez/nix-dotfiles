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
      foundry-pi = import inputs.nixpkgs-stable { system = "aarch64-linux"; };
      zima-blade = import inputs.nixpkgs-stable { system = "x86_64-linux"; };
    };
  };
  # nixberrypi = ./nixberrypi/configuration.nix;
  foundry-pi = ./foundry-pi/configuration.nix;
  zima-blade = ./zima-blade/configuration.nix;
}
