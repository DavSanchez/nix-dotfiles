{pkgs, ...}:
# Method for nix-doom-emacs (does not work)
let
  doom-emacs =
    pkgs.callPackage
    (builtins.fetchTarball {
      url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
      sha256 = "sha256:17d5fpsk7nj41zgd74p455wfiqx6x9xx3smdrlg7wklir5f92r2c";
    })
    {
      doomPrivateDir = ./doom.d; # Directory containing your config.el init.el
      # and packages.el files
    };
in {
  home.packages = [doom-emacs];
}
