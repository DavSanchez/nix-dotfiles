{ inputs, pkgs, ... }:
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
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-platforms = "x86_64-darwin aarch64-darwin";
    };

    gc = {
      automatic = false; # see programs.nh.clean
      interval.Day = 7;
    };

    linux-builder = {
      enable = true;
      ephemeral = true;
      # Read more at <https://nixcademy.com/posts/rosetta-linux-builder-macos/>
      package = pkgs.darwin.linux-builder-vz;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      config = {
        # virtualisation.darwin-builder.diskSize = 131072;
        # virtualisation.darwin-builder.memorySize = 16384;
      };
    };
  };
}
