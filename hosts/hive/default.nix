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
      zima-blade = import nixpkgs {
        system = "x86_64-linux";
      };
    };
  };
  # nixberrypi = ./nixberrypi/configuration.nix;
  foundry-pi = ./foundry-pi/configuration.nix;
  zima-blade = ./zima-blade/configuration.nix;
}
