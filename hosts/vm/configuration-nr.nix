{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.nix-relic.nixosModules.newrelic-infra
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions

      inputs.nix-relic.overlays.additions # new packages such as the infra agent and nrdot
    ];
  };

  services.newrelic-infra = {
    enable = true;
    configFile = ../../secrets/newrelic-infra-config.yml;
  };

  services.opentelemetry-collector = {
    enable = true;
    package = pkgs.nr-otel-collector;
    configFile = ../../secrets/nr-otel-collector-config.yml;
  };

  system.stateVersion = "23.05";

  # Configure networking
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  # Create user "test"
  services.getty.autologinUser = "test";
  users.users.test.isNormalUser = true;

  # Enable passwordless ‘sudo’ for the "test" user
  users.users.test.extraGroups = ["wheel"];
  security.sudo.wheelNeedsPassword = false;

  # Make VM output to the terminal instead of a separate window
  virtualisation.vmVariant.virtualisation.graphics = false;
}
