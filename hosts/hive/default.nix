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
      eter = import inputs.nixpkgs { system = "x86_64-linux"; };
    };
  };
  eter = ./eter/configuration.nix;
}
