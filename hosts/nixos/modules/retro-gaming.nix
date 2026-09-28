# Shared retro-gaming kiosk for the Pi 3B boards. It is exposed as a NixOS
# specialisation rather than the base system: `bruma` and `duende` boot as plain
# servers (text getty on the HDMI console), and `sudo gaming-mode on` swaps into
# the kiosk. `inheritParentConfig` defaults to true, so the specialisation is the
# server config plus cage/RetroArch/Bluetooth — activating it never stops any
# server service, and `sudo gaming-mode off` drops the kiosk-only units again.
#
# RetroArch is the frontend (nixpkgs has no EmulationStation) and `cage` launches
# it full-screen on tty1 as david, so there is no login prompt: the board goes
# straight into RetroArch and is driven with a controller. PS4/PS5 controllers
# pair over Bluetooth with `bluetoothctl` — a one-time, interactive step (needs a
# physical button press on the controller), not something to declare here.
{ lib, pkgs, ... }:
let
  # Cores picked for what a Pi 3B+ can actually run: 8/16-bit era plus PS1.
  retroarch = pkgs.retroarch.withCores (
    cores: with cores; [
      fceumm # NES
      snes9x # SNES
      genesis-plus-gx # Genesis/Mega Drive
      gambatte # GB/GBC
      mgba # GBA
      pcsx_rearmed # PS1 (ARM-optimized)
    ]
  );

  # `on`/`off` use the closures in the system profile, which always point at the
  # base generation: unlike /run/current-system it does not move into the
  # specialisation, so both directions resolve from either mode. `test` activates
  # the prebuilt closure without touching the bootloader or the profile.
  gaming-mode = pkgs.writeShellApplication {
    name = "gaming-mode";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.systemd
    ];
    text = ''
      root=/nix/var/nix/profiles/system
      case "''${1:-}" in
        on)
          [ "$(id -u)" -eq 0 ] || { echo "run as: sudo gaming-mode on" >&2; exit 1; }
          "$root/specialisation/gaming/bin/switch-to-configuration" test
          systemctl isolate graphical.target
          ;;
        off)
          [ "$(id -u)" -eq 0 ] || { echo "run as: sudo gaming-mode off" >&2; exit 1; }
          "$root/bin/switch-to-configuration" test
          systemctl isolate multi-user.target
          ;;
        status)
          if [ "$(readlink -f /run/current-system)" = "$(readlink -f "$root")" ]; then
            echo server
          else
            echo gaming
          fi
          ;;
        *)
          echo "usage: sudo gaming-mode {on|off|status}" >&2
          exit 2
          ;;
      esac
    '';
  };
in
{
  specialisation.gaming.configuration = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    environment.systemPackages = [
      retroarch
      pkgs.retroarch-joypad-autoconfig
    ];

    # ROMs live on the SD card itself, under david's home.
    systemd.tmpfiles.rules = [
      "d /home/david/ROMs 0755 david users - -"
    ];

    services.cage = {
      enable = true;
      user = "david";
      program = lib.getExe retroarch;
    };
  };

  environment.systemPackages = [
    gaming-mode
  ];
}
