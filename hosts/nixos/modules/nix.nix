{ inputs, ... }: {
  nixpkgs.config.allowUnfree = true;

  # Bring our custom packages from the 'pkgs' directory into the NixOS config,
  # mirroring hosts/darwin/modules/nix.nix and home/modules/nixpkgs.nix so a
  # package change (pkgs/**) affects the NixOS build too.
  nixpkgs.overlays = [
    inputs.self.overlays.additions
    inputs.self.overlays.stable-packages
    inputs.self.overlays.modifications
  ];

  nix = {
    settings = {
      trusted-users = [ "root" ];
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
    optimise.automatic = true;
  };
}
