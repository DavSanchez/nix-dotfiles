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
    {
      # macOS systems using nix-darwin
      darwinConfigurations = {
        "Davids-MacBook-Pro" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./system/mbp/darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              nixpkgs = {
                overlays = [
                  nur.overlay
                ];
                config.allowUnfreePredicate = (pkg: true);
              };
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.david = import ./home.nix;
                # Optionally, use home-manager.extraSpecialArgs to pass
                # arguments to home.nix
                # extraSpecialArgs = { };
              };
            }
          ];
        };
      };

      templates = import ./templates;
    }
    //
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ devshell.overlay ];
          };
        in
        {
          formatter = pkgs.nixpkgs-fmt;
          # Trying devShells and devshell as a better alternative to Makefile.
          # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop.html
          # https://github.com/numtide/devshell
          devShells.default = pkgs.devshell.mkShell {
            devshell.motd = ''
              {bold}{14}🔨 My home configs 🔨{reset}
              $(type -p menu &>/dev/null && menu)
            '';

            commands = [
              # # --- Fun ---
              # {
              #   name = "dev:hello";
              #   category = "Fun";
              #   help = "Print a nice hello world";
              #   command = ''
              #     nix run '.#figlet' -- -f isometric1 -c "Hello World"
              #   '';
              # }

              # --- Initial Setup ---
              {
                name = "dev:install";
                category = "Initial Setup";
                help = "Install home-manager itself and apply the home configuration";
                command = ''
                  export HOME_MANAGER_BACKUP_EXT=old
                  nix build --no-link '.#homeConfigurations.<user>.activationPackage'
                  "$(nix path-info '.#homeConfigurations.<user>.activationPackage')"/activate
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
              # {
              #   name = "dev:switch_mbp";
              #   category = "Home";
              #   help = "Switch home-manager to apply home config changes";
              #   command = ''
              #     home-manager switch --flake '.#david-mbp' -b bck --impure
              #   '';
              # }
              # {
              #   name = "dev:update";
              #   category = "Home";
              #   help = "Update things";
              #   command = ''
              #     home-manager switch --flake '.#david-mbp' -b bck --impure --recreate-lock-file
              #   '';
              # }
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

              # --- Darwin ---
              {
                name = "dev:switch_mbp";
                category = "Darwin";
                help = "Switch darwin to rebuild and apply `darwin-configuration.nix` changes";
                command = ''
                  nix build ".#darwinConfigurations.Davids-MacBook-Pro.system"
                  ./result/sw/bin/darwin-rebuild switch --flake ".#Davids-MacBook-Pro"
                '';
              }

              # # --- NixOS ---
              # {
              #   name = "dev:os-switch";
              #   category = "NixOS";
              #   help = "Switch nixos to rebuild and apply `configuration.nix` changes";
              #   command = ''
              #     sudo nixos-rebuild switch --flake '.#nixos' --impure
              #   '';
              # }

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
