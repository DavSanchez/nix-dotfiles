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
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      # The default (no options) runs plain `nix-collect-garbage`, which only
      # deletes unreachable paths; old system generations are GC roots, so they
      # are never collected and the store slowly fills the root filesystem.
      # 14 days keeps two weeks of rollbacks while bounding store growth.
      options = "--delete-older-than 14d";
    };
    optimise.automatic = true;
  };
}
