{ inputs, self, ... }:
let
  deployPkgs =
    system:
    import inputs.nixpkgs {
      inherit system;
      overlays = [
        inputs.deploy-rs.overlays.default
        (self: super: {
          deploy-rs = {
            inherit (import inputs.nixpkgs { inherit system; }) deploy-rs;
            lib = super.deploy-rs.lib;
          };
        })
      ];
    };
in
{
  flake.deploy.nodes = {
    eter = {
      hostname = "eter.local";
      profiles.system = {
        sshUser = "david";
        user = "root";
        remoteBuild = true;
        path = (deployPkgs "x86_64-linux").deploy-rs.lib.activate.nixos self.nixosConfigurations.eter;
      };
    };
    blackbee = {
      hostname = "blackbee.local";
      profiles.system = {
        sshUser = "david";
        user = "root";
        path = (deployPkgs "aarch64-linux").deploy-rs.lib.activate.nixos self.nixosConfigurations.blackbee;
      };
    };
  };

  perSystem =
    { system, ... }:
    {
      checks = (deployPkgs system).deploy-rs.lib.deployChecks self.deploy;
    };
}
