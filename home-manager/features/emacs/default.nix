{inputs, pkgs, ...}: {
  imports = [
    inputs.nix-doom-emacs.hmModule
  ];

  programs.doom-emacs = {
    enable = pkgs.stdenv.isLinux;
    doomPrivateDir = ./doom.d;
  };
  services.emacs.enable = pkgs.stdenv.isLinux;
}
