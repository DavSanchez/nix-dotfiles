{ pkgs, ... }:

# Method for nix-doom-emacs (does not work)
let
  doom-emacs = pkgs.callPackage
    (builtins.fetchTarball {
      url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
      # sha256 = "1nipiwiaypcrkrcls20prw28ly24s6dqd77vbmc12326kb1fy2w3";
    })
    {
      doomPrivateDir = ./doom.d; # Directory containing your config.el init.el
      # and packages.el files
    };
in
{
  home.packages = [ doom-emacs ];
}
