{pkgs, ...}: {
  imports = [
    ./foot.nix
    ./kitty.nix
    ./wezterm.nix # main
  ];

  # home.packages = with pkgs; [
  #   contour
  # ];

  programs = {
    oh-my-posh = {
      enable = false;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      settings = { };
      useTheme = null;
    };
  };
}
