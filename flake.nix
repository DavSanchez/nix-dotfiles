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
    # nixpkgs-firefox-darwin = {
    #   url = "github:bandithedoge/nixpkgs-firefox-darwin";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    taffybar = {
      url = "github:sherubthakur/taffybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Applying the configuration happens from the .dotfiles directory so the
    # relative path is defined accordingly. This has potential of causing issues.
    # vim-plugins = {
    #   url = "path:./modules/nvim/plugins";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nur, nixpkgs, home-manager, darwin, ... }:
    let
      # system = "aarch64-darwin";
      # pkgs = nixpkgs.legacyPackages.${system};
      home-common = { lib, ... }:
        {
          # NOTE: Here we are injecting colorscheme so that it is passed down all the imports
          _module.args = {
            colorscheme = import ./colorschemes/tokyonight.nix;
          };

          nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];

          nixpkgs.overlays = [
            nur.overlay
            taffybar.overlay
            # vim-plugins.overlay
          ];

          programs.home-manager.enable = true;
          home.stateVersion = "22.05";

          imports = [
            ./modules/cli.nix
            ./modules/direnv
            ./modules/fonts.nix
            ./modules/git
            ./modules/nvim
            ./modules/development
            ./modules/system
            ./modules/zsh
          ];
        };

      home-macbook = {
        # nixpkgs.overlays = [
        #   nixpkgs-firefox-darwin.overlay
        # ];
        home.homeDirectory = "/Users/david";
        home.username = "david";
        imports = [
          ./modules/nu/default-mac.nix
          ./modules/tmux
          ./modules/mac-symlink-applications.nix
        ];
        xdg.configFile."nix/nix.conf".text = ''
          experimental-features = nix-command flakes ca-references
        '';
      };

      #  Other systems
      # home-mac-mini = { };
    in
    {
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
        macbook-pro = home-manager.lib.homeManagerConfiguration {
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
