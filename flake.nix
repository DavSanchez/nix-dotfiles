{
  description = "DavSanchez's Nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's a working example:
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    # Also see the 'stable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

    nix-relic.url = "github:DavSanchez/Nix-Relic";
    nix-relic.inputs.nixpkgs.follows = "nixpkgs";

    # Editors
    ## NixVim
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

    # Uniform colors across all apps
    catppuccin.url = "github:catppuccin/nix";

    # Deployment
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      nixos-raspberrypi,
      deploy-rs,
      ...
    }@inputs:
    let
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
    in
    {
      # Custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      # Formatter for the nix files, available through 'nix fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable nix-darwin modules you might want to export
      # These are usually stuff you would upstream into nix-darwin
      darwinModules = import ./modules/darwin;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeModules = import ./modules/home-manager;

      # templates = import ./templates;

      nixosConfigurations = {
        blackbee = nixos-raspberrypi.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ./hosts/blackbee/configuration.nix
          ];
        };
        eter = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/eter/configuration.nix
          ];
        };
      };
      # macOS systems using nix-darwin
      darwinConfigurations = {
        sierpe = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/darwin/sierpe.nix
          ];
        };
        solio = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./hosts/darwin/solio.nix ];
        };
      };

      homeConfigurations = {
        "david@sierpe" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./home-manager/sierpe.nix ];
        };
        "david@solio" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./home-manager/solio.nix ];
        };
        "davidsanchez@nr" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./home-manager/home-nr.nix ];
        };
      };

      deploy.nodes = {
        eter = {
          hostname = "eter.local";
          profiles.system = {
            sshUser = "david";
            user = "root";
            remoteBuild = true;
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.eter;
          };
        };
        blackbee = {
          hostname = "blackbee.local";
          profiles.system = {
            sshUser = "david";
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.blackbee;
          };
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
