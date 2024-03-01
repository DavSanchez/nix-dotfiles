{pkgs, ...}: {
  imports = [
    ./foot.nix
    ./kitty.nix
    ./wezterm.nix # main
    ./rio
  ];

  programs = {
    oh-my-posh = {
      enable = false;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      settings = {};
      useTheme = null;
    };
  };
}
