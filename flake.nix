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
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    # Applying the configuration happens from the .dotfiles directory so the
    # relative path is defined accordingly. This has potential of causing issues.
    vim-plugins = {
      url = "path:./modules/nvim/plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nur, vim-plugins, nixpkgs, home-manager, flake-utils, devshell, darwin, ... }:
    let
      home-common = import ./home-common.nix;
      home-mbp = import ./home-mbp.nix;
    in
    {
      # NixOS systems
      # nixosConfiguration.nixos = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [ ./system/configuration.nix ];
      # };

      # macOS systems using nix-darwin
      # darwinConfigurations."Davids-Mac" = darwin.lib.darwinSystem {
      #   pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      #   modules = [
      #     ./modules/homebrew.nix
      #   ];
      # };

      homeConfigurations = {
        "david@mbp" = home-manager.lib.homeManagerConfiguration {
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
