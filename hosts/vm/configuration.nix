{pkgs, ...}: {
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
