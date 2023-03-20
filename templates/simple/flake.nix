{
  description = "A simple project template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    devshell.url = "github:numtide/devshell";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    devshell,
    ...
  }:
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = import nixpkgs {
        inherit system;

        overlays = [devshell.overlay];
      };
    in {
      devShells.default = pkgs.devshell.mkShell {
        devshell = {
          packages = with pkgs; [
            # deps here
          ];

          startup.shell-hook.text = ''
            echo "devShell started"
          '';

          motd = ''
            {bold}{14}🔨 Hello 🔨{reset}
            $(type -p menu &>/dev/null && menu)
          '';
        };

        commands = [
          {
            name = "sample-cmd";
            category = "Dev";
            help = "Init project";
            command = ''
              echo "hello world"
            '';
          }
        ];
      };
    });
}
