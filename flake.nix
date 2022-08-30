{
  description = "Nix configurations of David";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
  };

  outputs = { self, nur, nixpkgs, home-manager, flake-utils, devshell, darwin, ... }:
    let
      # system = "aarch64-darwin"; # This shouldn't be top level ??
      # pkgs = import nixpkgs {
      #   inherit system;
      #   overlays = [ devshell.overlay ];
      # };

      home-common = ./home-common.nix;
      home-macbook = ./home-macbook.nix;

      #  Other systems
      # home-mac-mini = { };
    in
    {
      formatter = {
        "aarch64-darwin" = nixpkgs.nixpkgs-fmt;
      };

      # NixOS systems
      # nixosConfiguration.nixos = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [ ./system/configuration.nix ];
      # };

      # macOS systems using nix-darwin
      # darwinConfigurations."Davids-Macbook-Pro" = darwin.lib.darwinSystem {
      #   pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      #   modules = [
      #     ./modules/homebrew.nix
      #   ];
      # };

      homeConfigurations = {
        # MBP 2021 M1
        david = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          modules = [
            home-common
            home-macbook
          ];
        };

        # Other systems (Nix-based, macOS...)
        # nixos = home-manager.lib.homeManagerConfiguration {
        #   pkgs = nixpkgs.legacyPackages."x86_64-linux";
        #   modules = [
        #     home-common
        #     home-linux
        #   ];
        # };
      };
    };
}
