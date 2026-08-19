# The Hermes Electron GUI. Standalone from services.hermes-agent: on a host
# with no backend/gateway running (see hermes-common.nix), the app spawns its
# own local backend on demand instead of connecting to a managed one.
{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = [
    inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.desktop
  ];
}
