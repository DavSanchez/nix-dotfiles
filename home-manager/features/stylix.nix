{ pkgs, ... }:
{
  stylix = {
    image = "../nixos-wallpaper-catppuccin-mocha.svg";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    fonts.monospace = {
      package = pkgs.nerd-fonts.iosevka;
      name = "Iosevka Nerd Font Mono";
    };
  };
}
