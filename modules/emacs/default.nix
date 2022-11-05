{pkgs, ...}:
# Method for nix-doom-emacs (does not work)
let
  doom-emacs =
    pkgs.callPackage
    (builtins.fetchTarball {
      url = "https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz";
      sha256 = "sha256:03w6nkyc72j4rszh1iyqb5p3n28w661bgc7dix6i5aygkf3sn86b";
    })
    {
      doomPrivateDir = ./doom.d; # Directory containing your config.el init.el
      # and packages.el files
    };
in {
  home.packages = [doom-emacs];
}
