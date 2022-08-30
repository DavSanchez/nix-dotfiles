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
      system = "aarch64-darwin"; # This shouldn't be top level ??
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ devshell.overlay ];
      };

      home-common = ./home-common.nix;
      home-macbook = ./home-macbook.nix;

      #  Other systems
      # home-mac-mini = { };
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;

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
    } //
    # currently my home configs support only aarch64-darwin.
    # So eachDefaultSystem doesn't mean much, but it's harmless as it is & I want to remember flake-utils is a thing, so I'll leave it here.
    flake-utils.lib.eachDefaultSystem
      (system:
        # let pkgs = nixpkgs.legacyPackages.${system};
        # in
        {
          # Trying devShells and devshell as a better alternative to Makefile.
          # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop.html
          # https://github.com/numtide/devshell

          devShells.default = pkgs.devshell.mkShell
            {
              devshell.motd = ''
                {bold}{14}🔨 My home conigs 🔨{reset}
                $(type -p menu &>/dev/null && menu)
              '';

              commands = [
                # --- Fun ---
                {
                  name = "dev:hello";
                  category = "Fun";
                  help = "Print a nice hello world";
                  command = ''
                    nix run '.#figlet' -- -f isometric1 -c "Hello World"
                  '';
                }

                # --- Initial Setup ---
                {
                  name = "dev:install";
                  category = "Initial Setup";
                  help = "Install home-manager itself and apply the home configuration";
                  command = ''
                    export HOME_MANAGER_BACKUP_EXT=old
                    nix run '.#activate/tars'
                    direnv allow
                  '';
                }

                # --- Home Environment ---
                {
                  name = "dev:ls-pkg";
                  category = "Home";
                  help = "List all packages installed in home-manager-path";
                  command = ''
                    home-manager packages
                  '';
                }
                {
                  name = "dev:ls-gen";
                  category = "Home";
                  help = "List all home environment generations";
                  command = ''
                    home-manager generations
                  '';
                }
                {
                  name = "dev:switch";
                  category = "Home";
                  help = "Switch home-manager to apply home config changes";
                  command = ''
                    home-manager switch --flake '.#tars' -b bck --impure
                  '';
                }
                {
                  name = "dev:update";
                  category = "Home";
                  help = "Update things";
                  command = ''
                    home-manager switch --flake '.#tars' -b bck --impure --recreate-lock-file
                  '';
                }
                {
                  name = "dev:update-nixpkgs";
                  category = "Home";
                  help = "Update nixpkgs only";
                  command = ''
                    nix flake lock --update-input nixpkgs
                    dev:switch
                  '';
                }
                {
                  name = "dev:update-lock-only";
                  category = "Home";
                  help = "Update the flake lock file only";
                  command = ''
                    nix flake update
                  '';
                }

                # --- NixOS ---
                {
                  name = "dev:os-switch";
                  category = "NixOS";
                  help = "Switch nixos to rebuild and apply `configuration.nix` changes";
                  command = ''
                    sudo nixos-rebuild switch --flake '.#tars' --impure
                  '';
                }

                # --- Utility ---
                {
                  name = "dev:fmt";
                  category = "Utility";
                  help = "Format nix files";
                  command = ''
                    nix fmt
                  '';
                }
                {
                  name = "dev:du-svg";
                  category = "Utility";
                  help = "Show what gc-roots are taking space (svg)";
                  command = ''
                    nix-du -s=500MB | tred | dot -Tsvg > store.svg
                  '';
                }
                {
                  name = "dev:du-png";
                  category = "Utility";
                  help = "Show what gc-roots are taking space (png)";
                  command = ''
                    nix-du -s=500MB | tred | dot -Tpng > store.png
                  '';
                }
                {
                  name = "dev:gc";
                  category = "Utility";
                  help = "Garbage collection";
                  command = ''
                    sudo nix-collect-garbage
                  '';
                }
                {
                  name = "dev:gc-stale";
                  category = "Utility";
                  help = ''Perform garbage collection and delete all generations older than 5 days'';
                  command = ''
                    sudo nix-collect-garbage -d --delete-older-than 5d
                  '';
                }
                {
                  name = "dev:gc-all";
                  category = "Utility";
                  help = ''Perform garbage collection and delete all old generations'';
                  command = ''
                    sudo nix-collect-garbage -d
                  '';
                }
              ];
            };
        });
}
