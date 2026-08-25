{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.sops-nix.darwinModules.sops

    ./modules/nix.nix
    ./modules/system.nix
    ./modules/shells.nix
    ./modules/services.nix
  ];

  users.users.david = {
    name = "davidsanchez";
    home = "/Users/davidsanchez";
  };

  nix.settings.trusted-users = [ "davidsanchez" ];

  # Was falling through to the upstream default (1 core / 3 GiB / 20 GiB) —
  # this host has 64 GB RAM / 10 cores, so match sierpe's allocation instead.
  nix.linux-builder = {
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 4;
      };
    };
  };

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
        trusted = true;
      }
      {
        name = "hashicorp/homebrew-tap";
        trusted = true;
      }
    ];
    brews = [
      "newrelic/commune/claude-nerd-completion"
      "newrelic/commune/newrelic-vault"
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
