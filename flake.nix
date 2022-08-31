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
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = { self, nur, nixpkgs, home-manager, flake-utils, devshell, darwin, ... }:
    let
      home-common = {
        # NOTE: Here we are injecting colorscheme so that it is passed down all the imports
        _module.args = {
          colorscheme = import ./colorschemes/tokyonight.nix;
        };
        nixpkgs.overlays = [
          nur.overlay
        ];
        # Allow all unfree packages
        nixpkgs.config.allowUnfreePredicate = (pkg: true);
        programs.home-manager.enable = true;
        home.stateVersion = "22.05";
        imports = [
          ./home-common.nix
        ];
      };
      home-mbp = {
        home.homeDirectory = "/Users/david";
        home.username = "david";
        xdg.configFile."nix/nix.conf".text = ''
          experimental-features = nix-command flakes
        '';
        imports = [
          ./home-mbp.nix
        ];
      };
    in
    {
      # NixOS systems
      # nixosConfiguration.nixos = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [ ./system/nixos/onfiguration.nix ];
      # };

      # macOS systems using nix-darwin
      # darwinConfigurations."Davids-Mac" = darwin.lib.darwinSystem {
      #   pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      #   modules = [
      #     ./system/mbp/configuration.nix
      #   ];
      # };

      homeConfigurations = {
        david-mbp = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          # inherit pkgs;
          modules = [
            home-common
            home-mbp
          ];
          # extraSpecialArgs = { };
        };
        # "david@nixos" = { };
      };

      templates = import ./templates;
    };
}
