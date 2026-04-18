_:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    trusted-users = [
      "root"
      "david"
    ];
    experimental-features = "nix-command flakes";
  };
  nix.optimise.automatic = true;
}
