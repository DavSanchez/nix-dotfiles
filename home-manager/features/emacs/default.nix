{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-doom-emacs.hmModule
  ];

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };
  services.emacs.enable = pkgs.stdenv.isLinux;
}
