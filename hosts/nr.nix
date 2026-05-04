{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.sops-nix.darwinModules.sops

    ./modules/darwin/nix.nix
    ./modules/darwin/system.nix
    ./modules/darwin/shells.nix
    ./modules/darwin/services.nix
  ];

  users.users.david = {
    name = "davidsanchez";
    home = "/Users/davidsanchez";
  };

  nix.settings.trusted-users = [ "davidsanchez" ];

  system.primaryUser = lib.mkForce "davidsanchez";

  system.configurationRevision = config.rev or config.dirtyRev or null;
  system.stateVersion = 6;
}
