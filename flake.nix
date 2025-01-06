{
  description = "DavSanchez's Nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's a working example:
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";
    # nix-colors.url = "github:misterio77/nix-colors";

    # nh with darwin support (to remove once <https://github.com/LnL7/nix-darwin/pull/942>) merges
    nh.url = "github:viperML/nh";

    nix-relic.url = "github:DavSanchez/Nix-Relic";
    nix-relic.inputs.nixpkgs.follows = "nixpkgs";

    # Editors
    ## NixVim
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
    # url = "github:nix-community/nixvim/nixos-23.05";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

    # Uniform colors across all apps?
    catppuccin.url = "github:catppuccin/nix";

    # Fix .app programs installed by Nix on Mac
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
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
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
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
      homeManagerModules = import ./modules/home-manager;

      templates = import ./templates;

      nixosConfigurations = {
        nr-vm-utm = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./hosts/vm/utm-nr/configuration.nix ];
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
            # ./hosts/darwin-builder
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
        "david@nr" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./home-manager/home-nr.nix ];
        };
      };

      colmena = import ./hosts/hive { inherit nixpkgs inputs; };
    };
}
