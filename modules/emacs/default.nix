{pkgs, ...}:
# Method for nix-doom-emacs (does not work)
let
  doom-emacs =
    pkgs.callPackage
    (builtins.fetchTarball {
      url = "https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz";
      sha256 = "sha256:1k4wxn84hgxmr2ddbmybnqqih07r22d3qfyx5rjl9fzw2p5kkxhk";
    })
    {
      doomPrivateDir = ./doom.d; # Directory containing your config.el init.el
      # and packages.el files
    };
in {
  home.packages = [doom-emacs];
}
