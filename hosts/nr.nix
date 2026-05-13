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

  homebrew = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    global.brewfile = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    taps = [
      {
        name = "newrelic/commune";
        clone_target = "git@source.datanerd.us:commune/newrelic-homebrew";
      }
    ];
    brews = [
      "mole"
      "newrelic/commune/claude-nerd-completion"
      "newrelic/commune/selfserve"
    ];
    casks = [
      "1password"
      "1password-cli"
      "affinity"
      "claude-code"
      "keymapp"
      "thaw"
      "virtualbox"
      "vlc"
      "wireshark-app"
    ];
  };
}
