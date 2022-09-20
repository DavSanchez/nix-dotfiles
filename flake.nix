{
  description = "Nix configurations of David";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    # nur = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , flake-utils
    , devshell
    , darwin
    , ...
    } @ inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = { allowUnfree = true; };
        overlays =
          attrValues self.overlays
          ++ singleton (
            # Sub in x86 version of packages that don't build on Apple Silicon yet
            final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
              inherit
                (final.pkgs-x86)
                idris2
                niv
                purescript
                ;
            })
          );
      };
    in
    {
      # macOS systems using nix-darwin
      darwinConfigurations = {
        "Davids-MacBook-Pro" = darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./system/mbp/darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
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
        "Davids-Mac-Mini" = darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./system/mini/darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.david = import ./home.nix;
              };
            }
          ];
        };
      };

      overlays = {
        # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev:
          optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            # Add access to x86 packages system is running Apple Silicon
            pkgs-x86 = import inputs.nixpkgs-unstable {
              system = "x86_64-darwin";
              inherit (nixpkgsConfig) config;
            };
          };
      };

      templates = import ./templates;
    }
    // flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlay ];
        };
      in
      {
        formatter = pkgs.alejandra;
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
                nix flake lock --update-input nixpkgs nixpkgs-unstable
                # dev:switch
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

            {
              name = "dev:switch_mini";
              category = "Darwin";
              help = "Switch darwin to rebuild and apply `darwin-configuration.nix` changes";
              command = ''
                nix build ".#darwinConfigurations.Davids-Mac-Mini.system"
                ./result/sw/bin/darwin-rebuild switch --flake ".#Davids-Mac-Mini"
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
