{pkgs, ...}:
# Method for nix-doom-emacs (does not work)
let
  doom-emacs =
    pkgs.callPackage
    (builtins.fetchTarball {
      url = "https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz";
      sha256 = "sha256:18w8lmkw150adf06pw5mjak4h6v4kkicqmc56vl8jn0gyrrb495y";
    })
    {
      doomPrivateDir = ./doom.d; # Directory containing your config.el init.el
      # and packages.el files
    };
in {
  home.packages = [doom-emacs];
}
