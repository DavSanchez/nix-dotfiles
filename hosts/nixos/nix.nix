_: {
  nixpkgs.config.allowUnfree = true;

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
