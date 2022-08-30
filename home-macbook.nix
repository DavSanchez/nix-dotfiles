{ ... }:
{
  # nixpkgs.overlays = [
  #   nixpkgs-firefox-darwin.overlay
  # ];
  home.homeDirectory = "/Users/david";
  home.username = "david";
  imports = [
    ./modules/nu/default-mac.nix
    # ./modules/tmux
    # ./modules/mac-symlink-applications.nix
  ];
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes ca-references
  '';
}
