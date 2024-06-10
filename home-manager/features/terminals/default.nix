_: {
  imports = [
    ./foot.nix
    ./kitty
    ./wezterm # main
    ./rio
  ];

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
