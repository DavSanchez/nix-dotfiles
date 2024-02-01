{
  description = "DavSanchez's Nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    devenv.url = "github:cachix/devenv/latest";

    nix-relic.url = "github:DavSanchez/Nix-Relic";
    nix-relic.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages =
      forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Formatter for the nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable nix-darwin modules you might want to export
    # These are usually stuff you would upstream into nix-darwin
    darwinModules = import ./modules/darwin;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    templates = import ./templates;

    nixosConfigurations = {
      nr-vm-utm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/vm/utm/configuration.nix
        ];
      };
    };
    # macOS systems using nix-darwin
    darwinConfigurations = {
      mbp = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/darwin/mbp.nix
          # ./hosts/darwin-builder
        ];
      };
      mini = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/darwin/mini.nix
        ];
      };
    };

    homeConfigurations = {
      "david@mbp" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home-mbp.nix
        ];
      };
      "david@mini" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home-mini.nix
        ];
      };
      "davidsanchez@nr-vm" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home-nr-vm.nix
        ];
      };
    };
  };
}
