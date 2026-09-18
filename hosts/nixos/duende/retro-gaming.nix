# Retro-gaming kiosk: RetroArch is the frontend (nixpkgs has no EmulationStation),
# launched full-screen on tty1 via `cage` so the board boots straight to it. PS4/PS5
# controllers pair over Bluetooth with `bluetoothctl` — a one-time, interactive step
# (needs a physical button press on the controller), not something to declare here.
{ pkgs, lib, ... }:
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
in
{
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
}
