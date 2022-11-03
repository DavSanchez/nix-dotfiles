{pkgs, ...}:
# Method for nix-doom-emacs (does not work)
let
  doom-emacs =
    pkgs.callPackage
    (builtins.fetchTarball {
      url = "https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz";
      sha256 = "sha256:056dfbpvrpdgbd5b5m7pnq8f4k0r7srw3p98cs3nd65rkai3fx2k";
    })
    {
      doomPrivateDir = ./doom.d; # Directory containing your config.el init.el
      # and packages.el files
    };
in {
  home.packages = [doom-emacs];
}
