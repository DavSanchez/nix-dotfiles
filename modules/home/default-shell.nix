{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.defaultShell;

  shells = {
    zsh = {
      enable = config.programs.zsh.enable;
      package = config.programs.zsh.package;
    };
    fish = {
      enable = config.programs.fish.enable;
      package = config.programs.fish.package;
    };
    nushell = {
      enable = config.programs.nushell.enable;
      package = config.programs.nushell.package;
    };
  };

  # `preferred` (when set) wins over the ordered list, so a host can pin a
  # shell without rewriting the whole priority.
  candidates = lib.unique (lib.optional (cfg.preferred != null) cfg.preferred ++ cfg.order);

  name = lib.findFirst (shell: shells.${shell}.enable) null candidates;
  package = if name == null then null else shells.${name}.package;
  executable = if package == null then null else lib.getExe package;

  # Shells that load nix-darwin's `/etc/zshenv` or `/etc/fish/config.fish` even
  # when run as a non-interactive script. nushell does neither.
  bootstrapName = lib.findFirst (shell: shells.${shell}.enable) null cfg.bootstrapOrder;

  # Home Manager is standalone here, so `programs.nushell.loadSessionVariables`
  # only captures `home.sessionVariables`/`home.sessionPath`; it never sources
  # nix-darwin's environment. GUI apps and launchd daemons (Herdr Core, VS Code,
  # Zed, …) also start without the login environment, so a nushell spawned from
  # there has no nix PATH at all. Running it through zsh/fish first is what
  # loads `/etc/zshenv` or `/etc/fish/config.fish`. Linux sessions already
  # inherit the system environment, so no wrapper is needed there.
  needsBootstrap = name == "nushell" && pkgs.stdenv.hostPlatform.isDarwin;

  launcher =
    if !needsBootstrap then
      null
    else if bootstrapName == "fish" then
      pkgs.writeScriptBin "default-shell" ''
        #!${lib.getExe shells.fish.package}
        exec ${executable} $argv
      ''
    else if bootstrapName == "zsh" then
      pkgs.writeScriptBin "default-shell" ''
        #!${lib.getExe shells.zsh.package}
        exec ${executable} "$@"
      ''
    else
      # macOS always ships zsh, and nix-darwin writes the login environment to
      # `/etc/zshenv`, so this works even without `programs.zsh.enable`.
      pkgs.writeScriptBin "default-shell" ''
        #!/bin/zsh
        exec ${executable} "$@"
      '';

  command = if launcher != null then "${launcher}/bin/default-shell" else executable;
in
{
  options.programs.defaultShell = {
    preferred = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "zsh"
          "fish"
          "nushell"
        ]
      );
      default = null;
      description = ''
        Shell to spawn in GUI apps and daemons, regardless of
        {option}`programs.defaultShell.order`. `null` leaves the order in
        charge.
      '';
    };

    order = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "zsh"
          "fish"
          "nushell"
        ]
      );
      default = [
        "nushell"
        "fish"
        "zsh"
      ];
      description = ''
        Shells to spawn in GUI apps and daemons, highest priority first. The
        first one whose Home Manager module is enabled wins.
      '';
    };

    bootstrapOrder = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "zsh"
          "fish"
        ]
      );
      default = [
        "fish"
        "zsh"
      ];
      description = ''
        Shells used only to load the login environment before exec'ing
        nushell, highest priority first. nix-darwin exports its environment
        through `/etc/zshenv` and `/etc/fish/config.fish`, which both read even
        for non-interactive scripts; nushell reads neither. On macOS this
        falls back to the system `/bin/zsh` when none are enabled.
      '';
    };

    name = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "zsh"
          "fish"
          "nushell"
        ]
      );
      readOnly = true;
      description = "The resolved shell, or `null` when none is enabled.";
    };

    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      readOnly = true;
      description = "The resolved shell's package, or `null`.";
    };

    executable = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      readOnly = true;
      description = "The resolved shell's executable, or `null`.";
    };

    launcher = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      readOnly = true;
      description = ''
        Bootstrap wrapper that loads the login environment and then execs
        nushell, or `null` when the resolved shell needs no wrapper.
      '';
    };

    command = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      readOnly = true;
      description = ''
        Executable to spawn: {option}`programs.defaultShell.launcher` when a
        wrapper is needed, otherwise {option}`programs.defaultShell.executable`.
        `null` when no shell is enabled.
      '';
    };

    argv = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      readOnly = true;
      description = ''
        {option}`programs.defaultShell.command` as an argument vector, for
        settings that take a command and its arguments as a list (herdr-core's
        `shell`). Empty when no shell is enabled.
      '';
    };
  };

  config = {
    programs.defaultShell = {
      inherit
        name
        package
        executable
        launcher
        command
        ;
      argv = lib.optional (command != null) command;
    };
  };
}
