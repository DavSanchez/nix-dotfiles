{ ... }:
{
  programs = {
    television.enable = true;

    # Generates the `nix-search-tv` cable channel for television
    nix-search-tv = {
      enable = true;
      settings = {
        indexes = [
          "nixpkgs"
          "home-manager"
          "nixos"
          "darwin"
          "nur"
          "noogle"
        ];
      };
    };
  };
}
