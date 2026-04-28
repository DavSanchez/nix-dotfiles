{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    protonmail-desktop
    protonmail-bridge
  ];

  programs.himalaya = {
    enable = true;
    # settings = { };
  };

  # ───────────────────────────────────────────────
  # Linux
  # ───────────────────────────────────────────────
  services.protonmail-bridge = {
    enable = pkgs.stdenv.isLinux;
  };

  # ───────────────────────────────────────────────
  # Darwin (until upstream home-manager adds launchd support)
  # ───────────────────────────────────────────────
  launchd.agents.protonmail-bridge = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        (lib.getExe pkgs.protonmail-bridge)
        "--noninteractive"
        # ]
        # ++ lib.optionals (cfg.logLevel != null) [
        #   "--log-level"
        #   cfg.logLevel
      ];
      KeepAlive = true;
      RunAtLoad = true;
      ProcessType = "Background";
      StandardOutPath = "/tmp/protonmail-bridge.log";
      StandardErrorPath = "/tmp/protonmail-bridge.err.log";
    };
  };
}
