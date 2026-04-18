{
  description = "DavSanchez's Nix configs";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Also see the 'stable-packages' overlay at 'overlays/default.nix'.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix-darwin
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    # flake-parts for modularizing nix code
    flake-parts.url = "github:hercules-ci/flake-parts";
    # Secret management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    # hardware-related
    hardware.url = "github:nixos/nixos-hardware";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    # other
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
    inputs@{ flake-parts, ... }:
    # https://flake.parts/module-arguments.html
    flake-parts.lib.mkFlake { inherit inputs; } (_: {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      imports = [
        ./modules/darwinConfigurations.nix
        ./modules/darwinModules.nix
        ./modules/deployNodes.nix
        ./modules/formatter.nix
        ./modules/homeConfigurations.nix
        ./modules/homeModules.nix
        ./modules/nixosConfigurations.nix
        ./modules/nixosModules.nix
        ./modules/overlays.nix
        ./modules/packages.nix
        ./modules/templates.nix
      ];
    });
}
