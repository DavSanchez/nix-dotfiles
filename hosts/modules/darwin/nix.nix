{ inputs, ... }:
{
  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.stable-packages
      inputs.self.overlays.modifications
    ];
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };

  nix = {
    settings = {
      trusted-users = [ "root" ];
      experimental-features = "nix-command flakes";
      extra-platforms = "x86_64-darwin aarch64-darwin";
    };

    gc = {
      automatic = false; # see programs.nh.clean
      interval.Day = 7;
    };

    linux-builder = {
      enable = true;
      ephemeral = true;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      config.boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
    };
  };
}
