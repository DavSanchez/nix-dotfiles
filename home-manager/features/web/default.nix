{ pkgs, ... }: {
  programs.librewolf = {
    enable = pkgs.stdenv.isLinux;
    settings = { };
  };
}
