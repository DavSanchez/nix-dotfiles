{nixpkgs, ...}: {
  meta = {
    nixpkgs = import nixpkgs {
      # Change it to the local arch-os you are using locally
      system = "aarch64-darwin";
    };
    nodeNixpkgs = {
      # nixberrypi = import nixpkgs {
      #   system = "aarch64-linux";
      # };
      foundry-pi = import nixpkgs {
        system = "aarch64-linux";
      };
    };
  };
  # nixberrypi = ./nixberrypi/configuration.nix;
  foundry-pi = ./foundry-pi/configuration.nix;
}
